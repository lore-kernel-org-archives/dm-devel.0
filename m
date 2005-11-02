From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: udev user specified or human readable /dev names
Date: Tue, 1 Nov 2005 16:35:31 -0800
Message-ID: <20051102003531.GA15854@us.ibm.com>
References: <20051101225357.GA13215@us.ibm.com>
	<20051102000531.GB17207@vrfy.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20051102000531.GB17207@vrfy.org>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: linux-hotplug-devel@lists.sourceforge.net, dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, Nov 02, 2005 at 01:05:31AM +0100, Kay Sievers wrote:
> On Tue, Nov 01, 2005 at 02:53:57PM -0800, Patrick Mansfield wrote:

> > If we could set and compare environment variables
> 
> Sure we can do that with ENV. '=' sets, '==' compares.
> 
> > or compare SYMLINK,
> 
> How would we compare the list of sysmlinks?
> True, if on of them matches?

Yes, perhaps:

SYMLINK == "* disk/by-id/scsi-360a98000686f68656c6e7a416f4b6849 *" SYMLINK+="user/name"

I like the above better than using other env variables, it is easier to
read.

> > separate rules file (doesn't have to be separate, just seems like a good
> > idea) could be used to add symlinks to user specified names.
> 
> All the persistent symlinks are composed from variables still available
> to match anytime later to add more links.
> 
> > i.e. move udev_rules.c:apply_format() into udev_utils.c, and call it
> > before comparison as well as before (AFAIUI) generating names, though I
> > somehow doubt the change is that simple.
> > 
> > Then, we could have rules like:
> > 
> > KERNEL=="sd*[!0-9]|sr*|dasd*[!0-9]", ENV{ID_SERIAL}=="?*", ENV{ID_FULL_PATH}="disk/by-id/$env{ID_BUS}-$env{ID_SERIAL}"
> > ENV{ID_FULL_PATH}=="?*", SYMLINK+="$env{ID_FULL_PATH}"
> 
> Hmm, why this indirection? Can't you just use ID_SERIAL and ID_BUS in
> the second rule again?

Yes, but it is simpler to use one variable, for this and in the by-id
partitions, rather than use "disk/by-id/$env{ID_BUS}-$env{ID_SERIAL}" in
multiple places (it is used in two places today, my scheme would mean two
more references).

But it still would not match, per the issue below, right?

> > Running with udev 069 on FC rawhide, with these rules:
> > 
> > SYMLINK=="*foo*" SYMLINK+="user/bar"
> 
> SYMLINK lists can't be matched until now.

You mean it is possible with current udev?

> > KERNEL="sdm" ENV{VAL1}="somevalue"
> > KERNEL="sdm" ENV{VAL2}="$env{VAL1}"
> 
> The value does not get expanded at the time you assign it, so the later compare
> will look like:
>   'somevalue' == '$env{VAL1}'
> 
> which does not match.

Right ... so should udev be changed to avoid that problem?

-- Patrick Mansfield
