From: malahal@us.ibm.com
Subject: Re: Removing a failed device from LVM2/DM
Date: Tue, 1 Sep 2009 12:08:43 -0700
Message-ID: <20090901190843.GA18641@us.ibm.com>
References: <1251731770.6817.31.camel@cail> <1251821775.5459.21.camel@cail>
	<20090901162537.GA15197@us.ibm.com>
	<1251830539.5459.135.camel@cail>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1251830539.5459.135.camel@cail>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Alan D. Brunelle [Alan.Brunelle@hp.com] wrote:
> #device/dev-cache.c:245         /dev/sdab: Already in device cache
> 
> How does one remove the cache? I tried remove /etc/lvm/cache/.cache &
> running vgscan, but no difference.
> 
> Alan

I think removing that file should help. What is your cache_dir setting
in /etc/lvm.conf file? You can completely remove that dir. On my
machine, cache_dir is set to /etc/lvm/cache and doing "rm -rf
/etc/lvm/cache" or "rm -f /etc/lvm/cache/.cache" should help.

BTW, the .cache file is just a text file, see what is there.

Thanks, Malahal.
