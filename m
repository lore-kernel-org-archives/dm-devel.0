From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] dm-raid.txt: document discard support
Date: Sat, 08 Aug 2015 12:27:14 -0400
Message-ID: <yq14mk9iw4d.fsf@sermon.lab.mkp.net>
References: <1438872279-30693-1-git-send-email-heinzm@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1438872279-30693-1-git-send-email-heinzm@redhat.com>
	(heinzm@redhat.com's message of "Thu, 6 Aug 2015 16:44:39 +0200")
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: heinzm@redhat.com
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

>>>>> "Heinz" == heinzm  <heinzm@redhat.com> writes:

Heinz,

> +Discard Support
> +---------------
> +The implementation of discard support amoung hardware vendors varies. When
> +a block is discarded, some storage devices will return zeros when it is
> +read.  These devices set the 'discard_zeros_data' attribute.  Other devices
> +will return random data.  Confusingly, some devices will set
> +'discard_zeros_data', but will still not always return zeros when
> +discarded blocks are read!

This used to be correct but that's no longer the case. We only set
discard_zeroes_data when we have hard guarantees. We no longer
exclusively rely on what the device reports.

discard_zeroes_data is only set if the device reports LBPME/LBPRZ and
uses WRITE SAME 10 or 16 (SCSI) or if it reports DRAT/RZAT and is
explicitly whitelisted (ATA).

-- 
Martin K. Petersen	Oracle Linux Engineering
