From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: 2 TB wraparound on 32 bit host
Date: Sat, 12 Jun 2010 11:03:18 -0500
Message-ID: <1276358598.4399.3.camel@mulgrave.site>
References: <4C12A32C.3000501@cfl.rr.com>
	<1276290990.2862.161.camel@mulgrave.site> <4C13AB90.1070802@cfl.rr.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4C13AB90.1070802@cfl.rr.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Phillip Susi <psusi@cfl.rr.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Sat, 2010-06-12 at 11:45 -0400, Phillip Susi wrote:
> On 06/11/2010 05:16 PM, James Bottomley wrote:
> > So best guess is that CONFIG_LBDAF isn't set.  This would make all
> > sector_t counts wrap at 2TB (32 bits worth of 512 bytes).  It would be
> > rather a daft thing for a distribution not to have set, though ...
> 
> Bingo, thanks.  It doesn't seem to be set on this machine running the 
> amd64 2.6.32 lucid build which also appears to suffer the same problem. 

So is this a default kernel or did you build your own ... because if
it's a vanilla ubuntu kernel, not setting this config option would be
pretty embarrassing (not to mention annoy a lot of users)?

>   If this config option isn't set though, shouldn't the kernel fail 
> calls like llseek() that try to exceed the limit, rather than silently 
> wrap around to the wrong address?

Not really ... it's defaulted to y; only people who know what they're
doing should set it to N.  These people are mostly embedded and will
never connect > 2TB devices to their system, so checking is a waste of
time and space for them.  Plus making the checks exhaustive and
foolproof is just about impossible given that we alter the underlying
size of sector_t and wrap around without warning is the C default.

James
