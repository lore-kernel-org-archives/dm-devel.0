From: Martin Wilck <mwilck@suse.com>
Subject: Re: libmultipath: fix null dereference
Date: Wed, 05 Aug 2020 23:31:00 +0200
Message-ID: <03adb8c54f9da84e997afa8ce354f46e3961d094.camel@suse.com>
References: <B8F26E5D3A1269458BE7CD6D60E9885F7A369633@dggemm531-mbx.china.huawei.com>
	<9458f4d0a17f98b4791e21efc91e779335edfb6f.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <9458f4d0a17f98b4791e21efc91e779335edfb6f.camel@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: lutianxiong <lutianxiong@huawei.com>, "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, Liaoqingwei <liaoqingwei@huawei.com>
List-Id: dm-devel.ids

On Wed, 2020-08-05 at 23:28 +0200, Martin Wilck wrote:
> On Thu, 2020-07-23 at 01:11 +0000, lutianxiong wrote:
> > 
> > Check if udev_device_get_devtype return NULL before dereferencing
> > it.
> >  
> > Signed-off-by: lutianxiong <lutianxiong@huawei.com>
> 
> Thanks, this looks correct. But could you please resend in proper
> format? The patch is corrupt, looks like mangled whitespace.
> 

I just saw that you did already, so forget about my previous request,
and thanks again.

Martin
