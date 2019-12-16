From: Xu Zaibo <xuzaibo@huawei.com>
Subject: [Question] Confusion of the meaning for encrypto API's
	return value
Date: Mon, 16 Dec 2019 15:18:54 +0800
Message-ID: <7a4edfcb-c140-bf1b-c674-dbb1b30f9b07@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: linux-crypto@vger.kernel.org, dm-devel@redhat.com
Cc: forest.zhouchang@huawei.com, zhangwei375@huawei.com
List-Id: dm-devel.ids

Hi,

I get a confusion.

According to my understanding, That 'crypto_skcipher_encrypt(request)' 
returns '-EBUSY '

means the caller should call this API again with the request. However, 
as my knowledge in

'dm-crypt', this means the caller need not call this request again, 
because 'dm-crypt' thinks

that the driver of 'crypto_skcipher_encrypt' will send the request again 
as it is not busy.

    So, my question is: what's the meaning of 
'crypto_skcipher_encrypt(request)' returning '-EBUSY '?


Cheers,

Zaibo


.
