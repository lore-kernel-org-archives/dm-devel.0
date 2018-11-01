From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm crypt: use unsigned long long instead of sector_t
 to store iv_offset
Date: Thu, 1 Nov 2018 16:06:42 -0400
Message-ID: <20181101200642.GA29073@redhat.com>
References: <1541062439-55558-1-git-send-email-alios_sys_security@linux.alibaba.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1541062439-55558-1-git-send-email-alios_sys_security@linux.alibaba.com>
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
Cc: dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Thu, Nov 01 2018 at  4:53am -0400,
AliOS system security <alios_sys_security@linux.alibaba.com> wrote:

> The iv_offset in the mapping table of crypt target is a 64bit number
> when iv mode is plain64 or plain64be. It will be assigned to iv_offset of
> struct crypt_config, cc_sector of struct convert_context and iv_sector of
> struct dm_crypt_request. These structures members are defined as a sector_t.
> But sector_t is 32bit when CONFIG_LBDAF is not set in 32bit kernel. In this
> situation sector_t is not big enough to store the 64bit iv_offset.

I really don't think this is needed.

cc->iv_offset can only address a the address space used to access the
device.  Which is expressed in terms of sectors.  Therefore if
CONFIG_LBDAF is not set in 32bit kernel then there is no need to address
beyond that which 'sector_t' addresses.

Please show proof to the contrary if you still think this change is
needed.

Mike
