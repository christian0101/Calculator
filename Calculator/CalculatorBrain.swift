//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Cristian Sorescu on 23/09/2017.
//  Copyright © 2017 Cristian Sorescu. All rights reserved.
//

import Foundation

class CalculatorBrain {
	
	private var accumulator = 0.0
	private var internalProgram = [AnyObject]()
	
	func setOperand(operand: Double) {
		accumulator = operand
		internalProgram.append(operand as AnyObject)
	}
	
	var operations: Dictionary<String, Operation> = [
		"π" : Operation.Constant(Double.pi),
		"e" : Operation.Constant(M_E),
		"±" : Operation.UnaryOpration({ (($0 != 0) ? -$0 : 0) }),
		"√" : Operation.UnaryOpration(sqrt),
		"cos" : Operation.UnaryOpration(cos),
		"×" : Operation.BinaryOperation({ $0 * $1 }),
		"÷" : Operation.BinaryOperation({ $0 / $1 }),
		"＋" : Operation.BinaryOperation({ $0 + $1 }),
		"−" : Operation.BinaryOperation({ $0 - $1 }),
        "mod" : Operation.BinaryOperation({ $0 % $1 }),
		"=" : Operation.Equals,
		"C" : Operation.Clear¡¡
	]
	
	enum Operation {
		case Constant(Double)
		case UnaryOpration((Double) -> Double)
		case BinaryOperation((Double, Double) -> Double)
		case Equals
		case Clear
	}
	
	func performOperation(symbol: String) {
		internalProgram.append(symbol as AnyObject)
		
		if let operation = operations [symbol] {
			switch operation {
			case .Constant(let value):
				accumulator = value
			case .UnaryOpration(let function):
				accumulator = function(accumulator)
			case .BinaryOperation(let function):
				executePendingBinaryOperation()
				pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator)
			case .Equals:
				executePendingBinaryOperation()
			case .Clear:
				clear()
			}
		}
	}
	
	private func executePendingBinaryOperation() {
		if pending != nil {
			accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
			pending = nil
		}
	}
	
	private var pending: PendingBinaryOperationInfo?
	
	private struct PendingBinaryOperationInfo {
		var binaryFunction: (Double, Double) -> Double
		var firstOperand: Double
	}
	
	typealias PropretyList = AnyObject
	
	var program: PropretyList {
		get {
			return internalProgram as CalculatorBrain.PropretyList
		}
		set {
			clear()
			
			if let arrayOfOps = newValue as? [AnyObject] {
				for op in arrayOfOps {
					if let operand = op as? Double {
						setOperand(operand: operand)
					} else if let operation = op as? String {
						performOperation(symbol: operation)
					}
				}
			}
		}
	}
	
	func clear () {
		accumulator = 0.0
		pending = nil
		internalProgram.removeAll()
	}
	
	var result: Double {
		get {
			return accumulator
		}
	}
}
