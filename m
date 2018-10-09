From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH 0/1] Fix kpart -d regression where matching
 devices not found
Date: Tue, 9 Oct 2018 14:38:44 +0200
Message-ID: <e3447c24-a42c-0abd-ea8f-963ae25749f2@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-GB
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Stef Walter <stefw@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Stef Walter wrote:

You should send(CC:) it also to Christophe.

> The Lorax project found a regression in kpartx -d behavior introduced
> by the following commit: 9bdfa3eb8e24b668e6c2bb882cddb0ccfe23ed5b
> 
> This patch should fix the problem. It's easy to reproduce this problem
> (I did it on Fedora 28) with the following commands:
> 
>         # kpartx -av disk.img
>         ...
>         # kpartx -dv disk.img
> 
> Notice that the loop devices and partition mappings created by the first
> command are not cleaned up by the second command.
> 
> Stef Walter (1):
>   kpartx: Use absolute paths to create mappings
> 
>  kpartx/kpartx.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
