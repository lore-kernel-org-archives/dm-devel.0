From: "Y. D." <duyuyang@gmail.com>
Subject: Can we use blktrace to do snapshot of a block device?
Date: Thu, 11 Dec 2008 17:26:10 +0800
Message-ID: <200812111726093187607@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi All,

I want to do a software mirroring of a block device. I find that blktrace is an excellent tool to begin with.
However, I find blktrace only gets the parameters of the block device requests. Is it feasible to enhance
blktrace as to do mirroring of a block device?

Can anyone help with that?

Thanks in advance,
Shawn
