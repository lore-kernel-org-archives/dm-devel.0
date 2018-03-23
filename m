From: Denis Semakin <d.semakin@omprussia.ru>
Subject: Re: [PATCH] dm table: add support for secure erase
 forwarding [was: Re: Adaptation secure erase forwarding for 4.1x kernels]
Date: Fri, 23 Mar 2018 18:25:20 +0300 (MSK)
Message-ID: <1355528328.319961.1521818720538.JavaMail.zimbra@omprussia.ru>
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
To: snitzer <snitzer@redhat.com>
Cc: dm-devel <dm-devel@redhat.com>
List-Id: dm-devel.ids

Additional.

>Which DM target(s) have you been wanting to pass REQ_OP_SECURE_ERASE
>bios?
I've tested only with linear targets, so I suppose it's needed to
check what kind of target(s) we have.

Denis
