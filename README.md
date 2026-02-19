# Project1: Gate-Level DMA Engine

## 프로젝트 소개
Gate-Level 기반 DMA 엔진을 FSM 인코딩 방식에 따른 두 가지 방식으로 설계한 프로젝트입니다.  

## 프로젝트 핵심
- FSM 인코딩 방식 비교
  - `STEP1_ONEHOT`: One-hot 인코딩
  - `STEP2_NORMAL`: 일반(Binary) 인코딩

## 프로젝트 개요
- 목표: 동일 DMA 기능을 서로 다른 FSM 인코딩으로 구현
- 주요 파일
  - `STEP1_ONEHOT/DMAC/RTL/DMAC_ENGINE.sv`
  - `STEP2_NORMAL/DMAC/RTL/DMAC_ENGINE.sv`
- 실행 스크립트: 각 Step의 `DMAC/SIM` 내 `run.compile`, `run.sim`, `run.waveform`, `run.verdi`

## 환경
- OS: Linux
- EDA Toolchain: Synopsys
- VCS: Synopsys Verilog/SystemVerilog 시뮬레이터 (Compile/Simulation 실행)
- Verdi: Synopsys 디버깅/파형 분석

## 저장소 구조
```text
.
├── README.md
├── .gitignore
├── STEP1_ONEHOT
│   ├── scripts
│   │   └── common.sh
│   └── DMAC
│       ├── RTL
│       │   ├── DMAC_TOP.sv
│       │   ├── DMAC_CFG.sv
│       │   ├── DMAC_ENGINE.sv
│       │   ├── gatelevel.sv
│       │   ├── sead32nm_simple.v
│       │   └── filelist.f
│       └── SIM
│           ├── TB
│           │   ├── AXI_INTF.sv
│           │   ├── AXI_SLAVE.sv
│           │   ├── AXI_TYPEDEF.svh
│           │   ├── DMAC_TOP_TB.sv
│           │   ├── FIFO.sv
│           │   ├── timescale.v
│           │   └── filelist.f
│           ├── run.compile
│           ├── run.sim
│           ├── run.waveform
│           ├── run.verdi
│           ├── sim_result_step1.png
│           ├── Step1_waveform(1).jpg
│           └── Step1_waveform(2).jpg
└── STEP2_NORMAL
    ├── scripts
    │   └── common.sh
    └── DMAC
        ├── RTL
        │   ├── DMAC_TOP.sv
        │   ├── DMAC_CFG.sv
        │   ├── DMAC_ENGINE.sv
        │   ├── gatelevel.sv
        │   ├── sead32nm_simple.v
        │   └── filelist.f
        └── SIM
            ├── TB
            │   ├── AXI_INTF.sv
            │   ├── AXI_SLAVE.sv
            │   ├── AXI_TYPEDEF.svh
            │   ├── DMAC_TOP_TB.sv
            │   ├── FIFO.sv
            │   ├── timescale.v
            │   └── filelist.f
            ├── run.compile
            ├── run.sim
            ├── run.waveform
            ├── run.verdi
            ├── sim_result_step2.png
            ├── Step2_waveform(1).jpg
            └── Step2_waveform(2).jpg
```
