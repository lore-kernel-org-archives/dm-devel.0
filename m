From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: 2 TB wraparound on 32 bit host
Date: Sat, 12 Jun 2010 11:45:20 -0400
Message-ID: <4C13AB90.1070802@cfl.rr.com>
References: <4C12A32C.3000501@cfl.rr.com>
	<1276290990.2862.161.camel@mulgrave.site>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1276290990.2862.161.camel@mulgrave.site>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 06/11/2010 05:16 PM, James Bottomley wrote:
> So best guess is that CONFIG_LBDAF isn't set.  This would make all
> sector_t counts wrap at 2TB (32 bits worth of 512 bytes).  It would be
> rather a daft thing for a distribution not to have set, though ...

Bingo, thanks.  It doesn't seem to be set on this machine running the 
amd64 2.6.32 lucid build which also appears to suffer the same problem. 
  If this config option isn't set though, shouldn't the kernel fail 
calls like llseek() that try to exceed the limit, rather than silently 
wrap around to the wrong address?
