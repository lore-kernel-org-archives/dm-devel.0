From: Dennis Semakin <insane79@yandex.ru>
Subject: Forward SECDISCARD request within device mapper layer
Date: Fri, 16 Feb 2018 14:38:00 +0300
Message-ID: <4411521518781080@web43j.yandex.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
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
To: jbrassow@redhat.com, agk@redhat.com, asi@seznam.cz, j-nomura@ce.jp.nec.com, andmike@linux.vnet.ibm.com, christophe.varoqui@free.fr, bmarzins@redhat.com, k-ueda@ct.jp.nec.com, snitzer@redhat.com, dm-devel@redhat.com
List-Id: dm-devel.ids

Hello.

Recently I've submitted the patch https://patchwork.kernel.org/patch/10182691/
about forwarding SECDISCARD request.
May I know your thoughts about it? Is it so bad and ugly? Is it so unneeded to provide this request?
I just want to know your opinion. 
If it's not applicable then I could re-write it.
I've successfully tested it for 3.10 and 3.18 kernels.

Best regards,
Denis Semakin
