From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm crypt: use unsigned long long instead of sector_t
 to store iv_offset
Date: Fri, 2 Nov 2018 12:11:49 -0400
Message-ID: <20181102161149.GA1406@redhat.com>
References: <1541062439-55558-1-git-send-email-alios_sys_security@linux.alibaba.com>
	<20181101200642.GA29073@redhat.com>
	<0064ec33-196d-7ff4-51a4-9270389ac2aa@linux.alibaba.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <0064ec33-196d-7ff4-51a4-9270389ac2aa@linux.alibaba.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: AliOS system security <alios_sys_security@linux.alibaba.com>
Cc: dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

On Fri, Nov 02 2018 at 12:31am -0400,
AliOS system security <alios_sys_security@linux.alibaba.com> wrote:

> On 2018/11/2 4:06, Mike Snitzer wrote:
> >On Thu, Nov 01 2018 at  4:53am -0400,
> >AliOS system security <alios_sys_security@linux.alibaba.com> wrote:
> >
> >>The iv_offset in the mapping table of crypt target is a 64bit number
> >>when iv mode is plain64 or plain64be. It will be assigned to iv_offset of
> >>struct crypt_config, cc_sector of struct convert_context and iv_sector of
> >>struct dm_crypt_request. These structures members are defined as a sector_t.
> >>But sector_t is 32bit when CONFIG_LBDAF is not set in 32bit kernel. In this
> >>situation sector_t is not big enough to store the 64bit iv_offset.
> >I really don't think this is needed.
> >
> >cc->iv_offset can only address a the address space used to access the
> >device.  Which is expressed in terms of sectors.  Therefore if
> >CONFIG_LBDAF is not set in 32bit kernel then there is no need to address
> >beyond that which 'sector_t' addresses.
> >
> >Please show proof to the contrary if you still think this change is
> >needed.
> >
> >Mike
> 
> 
> Sorry I made a mistake. I read
> Documentation/device-mapper/dm-crypt.txt again and found that the IV
> offset is a sector count. So it make sense to store the iv_offset as
> a sector_t.
> 
> In addition, I want to describe what problem I met in the beginning.
> I made a crypt.img with the crypt param
> "aes-cbc-plain64 0x1234...5678 1311768465173141112 /dev/loop0 0" in
> a 32bit kernel with CONFIG_LBDAF=y.
> The iv_offset is set to a 64bit number and the iv mode is set to
> plain64. Someday I recompiled my kernel but
> CONFIG_LBDAF is not set this time. When I reload the crypt.img with
> the same crypt param in new kernel,
> I got ioctl(..., DM_TABLE_LOAD, ...) return 0 but the content of
> /dev/dm-0 is incorrect.
> 
> So, is this situation, set the iv mode to plain64 or plain64be in a
> 32bit kernel with CONFIG_LBDAF is not set, a problem? Should the
> crypt_ctr() return an error code when this happned? Or we just
> support 64bit iv mode
> all the time regardless of CONFIG_LBDAF?

Please see Milan's reply from earlier today.  You did find a real bug.
Milan is going to iterate on your patch (likely switch to using uint64_t
and update the patch header to capture all the useful context for why
this is a real issue -- albeit one that has apparently been around since
2.6.20).

I'll still attribute the change to you, but Milan's contribution will be
an incremental improvement on your initial patch.

Thanks for reporting and fixing this.

Mike
