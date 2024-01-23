//
//  PriorityLine.swift
//  DoIt2
//
//  Created by Nikita Ivanov on 28/12/2023.
//

import UIKit
import SnapKit

enum Priorities: Int16, CaseIterable {
  case none, low, medium, high
  
  var color: UIColor {
    switch self {
    case .none:
      return .gray
    case .low:
      return .green
    case .medium:
      return .yellow
    case .high:
      return .red
    }
  }
}

final class PriorityLineView: UIView {
  private let sgmntNone = UIView()
  private let sgmntLow = UIView()
  private let sgmntMed = UIView()
  private let sgmntHigh = UIView()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupUI()
  }

  private func setupUI() {
    [sgmntNone, sgmntLow, sgmntMed, sgmntHigh].forEach {
      addSubview($0)
      $0.backgroundColor = color(for: $0)
    }
    
    sgmntNone.snp.makeConstraints { make in
      make.left.equalToSuperview()
      make.top.bottom.equalToSuperview()
      make.width.equalTo(sgmntLow.snp.width)
    }
    
    sgmntLow.snp.makeConstraints { make in
      make.left.equalTo(sgmntNone.snp.right)
      make.top.bottom.equalToSuperview()
      make.width.equalTo(sgmntMed.snp.width)
    }
    
    sgmntMed.snp.makeConstraints { make in
      make.left.equalTo(sgmntLow.snp.right)
      make.top.bottom.equalToSuperview()
      make.width.equalTo(sgmntHigh.snp.width)
    }
    
    sgmntHigh.snp.makeConstraints { make in
      make.left.equalTo(sgmntMed.snp.right)
      make.top.bottom.right.equalToSuperview()
    }
  }

  private func color(for segment: UIView) -> UIColor {
    switch segment {
    case sgmntNone:
      return Priorities.none.color
    case sgmntLow:
      return Priorities.low.color
    case sgmntMed:
      return Priorities.medium.color
    case sgmntHigh:
      return Priorities.high.color
    default:
      return .clear
    }
  }
}
