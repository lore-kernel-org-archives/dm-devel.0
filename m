From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: [PATCH 2/2] Use low pointer bits for dm io region
Date: Wed, 11 Nov 2009 16:26:15 +0900
Message-ID: <4AFA6717.2060305@ct.jp.nec.com>
References: <Pine.LNX.4.64.0911102104350.23116@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0911102104350.23116@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Hi Mikulas,

On 11/11/2009 11:05 AM +0900, Mikulas Patocka wrote:
> Use low pointer bits for dm io region
> 
> We need to store two things per bio: the pointer to the main io structure and
> a region number, an index of disk where this bio belongs to (if there is
> simultaneous write to multiple disks). There can be at most BITS_PER_LONG
> regions. BITS_PER_LONG is 32 on 32-bit machines and 64 on 64-bit machines.
> 
> A region number was stored in the last hidden bio vector and the pointer to
> struct io was stored in bi_private.
> 
> This patch changes it so that "struct io" is always aligned on BITS_PER_LONG
> bytes and region number is stored in the low BITS_PER_LONG bits of bi_private.

The code is not easily readable for me.
Why don't you introduce a new structure in which those two things
can be stored, and allocate/attach it per bio?
If it's possible, the code should be easy to read and maintain, I think.

Thanks,
Kiyoshi Ueda
