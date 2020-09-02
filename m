From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: flood of "dm-X: error: dax access failed" due to 5.9
 commit 231609785cbfb
Date: Wed, 2 Sep 2020 23:05:15 +0000
Message-ID: <8dc419e607ffa0e2baa6bd5795b4956fb945ebad.camel@intel.com>
References: <20200902160432.GA5513@redhat.com>
	<df0203fa-7f75-53ac-8bf1-79a1c861918e@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <df0203fa-7f75-53ac-8bf1-79a1c861918e@suse.de>
Content-ID: <DA97FB514C8ECD42BA421E213FBFF734@namprd11.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Language: en-US
To: "pankaj.gupta.linux@gmail.com" <pankaj.gupta.linux@gmail.com>, "snitzer@redhat.com" <snitzer@redhat.com>, "colyli@suse.de" <colyli@suse.de>, "jack@suse.com" <jack@suse.com>, "Weiny, Ira" <ira.weiny@intel.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-Id: dm-devel.ids

On Thu, 2020-09-03 at 00:40 +0800, Coly Li wrote:
> On 2020/9/3 00:04, Mike Snitzer wrote:
> > 5.9 commit 231609785cbfb ("dax: print error message by pr_info() in
> > __generic_fsdax_supported()") switched from pr_debug() to pr_info().
> > 
> > The justification in the commit header is really inadequate.  If there
> > is a problem that you need to drill in on, repeat the testing after
> > enabling the dynamic debugging.
> > 
> > Otherwise, now all DM devices that aren't layered on DAX capable devices
> > spew really confusing noise to users when they simply activate their
> > non-DAX DM devices:
> > 
> > [66567.129798] dm-6: error: dax access failed (-5)
> > [66567.134400] dm-6: error: dax access failed (-5)
> > [66567.139152] dm-6: error: dax access failed (-5)
> > [66567.314546] dm-2: error: dax access failed (-95)
> > [66567.319380] dm-2: error: dax access failed (-95)
> > [66567.324254] dm-2: error: dax access failed (-95)
> > [66567.479025] dm-2: error: dax access failed (-95)
> > [66567.483713] dm-2: error: dax access failed (-95)
> > [66567.488722] dm-2: error: dax access failed (-95)
> > [66567.494061] dm-2: error: dax access failed (-95)
> > [66567.498823] dm-2: error: dax access failed (-95)
> > [66567.503693] dm-2: error: dax access failed (-95)
> > 
> > commit 231609785cbfb must be reverted.
> > 
> > Please advise, thanks.
> 
> Adrian Huang from Lenovo posted a patch, which titled: dax: do not print
> error message for non-persistent memory block device
> 
> It fixes the issue, but no response for now. Maybe we should take this fix.
> 

Mike, Coly,

I applied Adrians patch, and submitted it - it is already in v5.9-rc3 -
c2affe920b0e dax: do not print error message for non-persistent memory block device
