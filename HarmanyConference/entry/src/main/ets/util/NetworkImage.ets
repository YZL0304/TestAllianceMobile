import http from '@ohos.net.http';

@Component
export struct NetworkImage {
  @Prop url: string;

  @State private imageBase64: string = '';
  @State private loadFailed: boolean = false;

  aboutToAppear() {
    const httpRequest: http.HttpRequest = http.createHttp();
    httpRequest.request(
      this.url,
      {
        method: http.RequestMethod.GET,
        expectDataType: http.HttpDataType.ARRAY_BUFFER,
      },
      (err: Error | undefined, data: http.HttpResponse) => {
        if (err || !data.result) {
          this.loadFailed = true;
          return;
        }

        const byteArray = new Uint8Array(data.result as ArrayBuffer);
        let binary = '';
        for (let i = 0; i < byteArray.length; i++) {
          binary += String.fromCharCode(byteArray[i]);
        }
        this.imageBase64 = `data:image/jpeg;base64,${this.base64Encode(binary)}`;
      }
    );
  }

  private base64Encode(input: string): string {
    const chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
    let output = '';
    let i = 0;

    while (i < input.length) {
      const c1 = input.charCodeAt(i++) & 0xff;
      if (i === input.length) {
        output += chars.charAt(c1 >> 2);
        output += chars.charAt((c1 & 0x3) << 4);
        output += '==';
        break;
      }
      const c2 = input.charCodeAt(i++);
      if (i === input.length) {
        output += chars.charAt(c1 >> 2);
        output += chars.charAt(((c1 & 0x3) << 4) | ((c2 & 0xf0) >> 4));
        output += chars.charAt((c2 & 0xf) << 2);
        output += '=';
        break;
      }
      const c3 = input.charCodeAt(i++);
      output += chars.charAt(c1 >> 2);
      output += chars.charAt(((c1 & 0x3) << 4) | ((c2 & 0xf0) >> 4));
      output += chars.charAt(((c2 & 0xf) << 2) | ((c3 & 0xc0) >> 6));
      output += chars.charAt(c3 & 0x3f);
    }

    return output;
  }

  build() {
    if (this.loadFailed || !this.imageBase64) {
      Text('图片加载失败')
    } else {
      Image(this.imageBase64)
    }
  }
}
