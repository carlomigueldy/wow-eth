import { ethers } from "ethers";

class AppLogger {
  #name: string;
  #console: boolean;

  constructor(name: string, console?: boolean) {
    this.#name = name;
    this.#console = console ?? false;
  }

  public v(...args: any[]) {
    ethers.logger.debug(`${this.#name} | `, ...args);
    if (this.#console) console.debug(`${this.#name} | `, ...args);
  }

  public i(...args: any[]) {
    ethers.logger.info(`💡 ${this.#name} | `, ...args);
    if (this.#console) console.info(`💡 ${this.#name} | `, ...args);
  }

  public s(...args: any[]) {
    ethers.logger.info(`✅ ${this.#name} | `, ...args);
    if (this.#console) console.info(`✅ ${this.#name} | `, ...args);
  }

  public w(...args: any[]) {
    ethers.logger.warn(`⚠️ ${this.#name} | `, ...args);
    if (this.#console) console.warn(`⚠️ ${this.#name} | `, ...args);
  }

  public e(...args: any[]) {
    ethers.logger.info(`🐞 ${this.#name} | `, ...args);
    if (this.#console) console.error(`🐞 ${this.#name} | `, ...args);
  }
}

export function useLogger(name: string, console?: boolean) {
  return new AppLogger(name, console);
}
