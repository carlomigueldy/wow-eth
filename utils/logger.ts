import { ethers } from "ethers";

class AppLogger {
  #name: string;

  constructor(name: string) {
    this.#name = name;
  }

  public v(...args: any[]) {
    ethers.logger.debug(`${this.#name} | `, ...args);
  }

  public i(...args: any[]) {
    ethers.logger.info(`💡 ${this.#name} | `, ...args);
  }

  public s(...args: any[]) {
    ethers.logger.info(`✅ ${this.#name} | `, ...args);
  }

  public w(...args: any[]) {
    ethers.logger.warn(`⚠️ ${this.#name} | `, ...args);
  }

  public e(...args: any[]) {
    ethers.logger.info(`🐞 ${this.#name} | `, ...args);
  }
}

export function useLogger(name: string) {
  return new AppLogger(name);
}
