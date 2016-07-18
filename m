From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH] multipath-tools: replace <> with "" for
 local headers
Date: Mon, 18 Jul 2016 17:32:43 +0200
Message-ID: <41d00ab9-610b-ddaf-1c4a-89456b229b14@gmail.com>
References: <1468852952-9073-1-git-send-email-xose.vazquez@gmail.com>
	<0c89b48e-a52d-a3ff-6673-4400e25d43ae@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <0c89b48e-a52d-a3ff-6673-4400e25d43ae@sandisk.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 07/18/2016 05:07 PM, Bart Van Assche wrote:
> On 07/18/2016 07:42 AM, Xose Vazquez Perez wrote:
>> [ ... ]
> 
> Was this perhaps reported by clang and has the resulting
> patch been verified with clang? If so, please mention this
> in the patch description. In that case:

I did not use clang, and splint was (only) the trigger.
Mainly it was done with scripts.

All my patches are, at least, compile-tested. Usually with
gcc, but sometimes also with clang.
