From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: udev user specified or human readable /dev names
Date: Wed, 2 Nov 2005 02:06:15 +0100
Message-ID: <20051102010615.GA18684@vrfy.org>
References: <20051101225357.GA13215@us.ibm.com> <20051102000531.GB17207@vrfy.org> <20051102003531.GA15854@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-hotplug-devel-admin@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <20051102003531.GA15854@us.ibm.com>
Sender: linux-hotplug-devel-admin@lists.sourceforge.net
Errors-To: linux-hotplug-devel-admin@lists.sourceforge.net
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-hotplug-devel>,
	<mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Post: <mailto:linux-hotplug-devel@lists.sourceforge.net>
List-Help: <mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-hotplug-devel>,
	<mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=subscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-hotplug-devel>
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: linux-hotplug-devel@lists.sourceforge.net, dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, Nov 01, 2005 at 04:35:31PM -0800, Patrick Mansfield wrote:
> On Wed, Nov 02, 2005 at 01:05:31AM +0100, Kay Sievers wrote:
> > On Tue, Nov 01, 2005 at 02:53:57PM -0800, Patrick Mansfield wrote:
> 
> > > If we could set and compare environment variables
> > 
> > Sure we can do that with ENV. '=' sets, '==' compares.
> > 
> > > or compare SYMLINK,
> > 
> > How would we compare the list of sysmlinks?
> > True, if on of them matches?
> 
> Yes, perhaps:
> 
> SYMLINK == "* disk/by-id/scsi-360a98000686f68656c6e7a416f4b6849 *" SYMLINK+="user/name"
> 
> I like the above better than using other env variables, it is easier to
> read.
> 
> > > separate rules file (doesn't have to be separate, just seems like a good
> > > idea) could be used to add symlinks to user specified names.
> > 
> > All the persistent symlinks are composed from variables still available
> > to match anytime later to add more links.
> > 
> > > i.e. move udev_rules.c:apply_format() into udev_utils.c, and call it
> > > before comparison as well as before (AFAIUI) generating names, though I
> > > somehow doubt the change is that simple.
> > > 
> > > Then, we could have rules like:
> > > 
> > > KERNEL=="sd*[!0-9]|sr*|dasd*[!0-9]", ENV{ID_SERIAL}=="?*", ENV{ID_FULL_PATH}="disk/by-id/$env{ID_BUS}-$env{ID_SERIAL}"
> > > ENV{ID_FULL_PATH}=="?*", SYMLINK+="$env{ID_FULL_PATH}"
> > 
> > Hmm, why this indirection? Can't you just use ID_SERIAL and ID_BUS in
> > the second rule again?
> 
> Yes, but it is simpler to use one variable, for this and in the by-id
> partitions, rather than use "disk/by-id/$env{ID_BUS}-$env{ID_SERIAL}" in
> multiple places (it is used in two places today, my scheme would mean two
> more references).

Why do you want to match on the whole string which is a result from another
rule hidden in a symlink array? The whole idea of IMPORT the ID_* keys is to
have these variables in the environment to compose device names. Think
of them as a "poor mans product database".

The only interesting parts of the symlink string you want to match are the
two values which are conveniently available in the environment for exactly
that reason. :)

> But it still would not match, per the issue below, right?

Right, it wouldn't work.

You want this:
  ENV{ID_FULL_PATH}=="disk/by-id/scsi-360a98000686f68656c6e7a416f4b6849" SYMLINK+="media-files"

but why don't you just do:
  ENV{ID_BUS}=="scsi", ENV{ID_SERIAL}=="360a98000686f68656c6e7a416f4b6849", SYMLINK+="media-files"

The second already works, is independent from all other rules and I think
is simpler.

> > > Running with udev 069 on FC rawhide, with these rules:
> > > 
> > > SYMLINK=="*foo*" SYMLINK+="user/bar"
> > 
> > SYMLINK lists can't be matched until now.
> 
> You mean it is possible with current udev?

No, there is no change in the current udev.

> > > KERNEL="sdm" ENV{VAL1}="somevalue"
> > > KERNEL="sdm" ENV{VAL2}="$env{VAL1}"
> > 
> > The value does not get expanded at the time you assign it, so the later compare
> > will look like:
> >   'somevalue' == '$env{VAL1}'
> > 
> > which does not match.
> 
> Right ... so should udev be changed to avoid that problem?

Sure, we can, but I fear that this will end in something like a shell. :)
And I've seen people storing REMOVE hooks in the database that get
expanded at remove time and not before they are stored...

Kay


-------------------------------------------------------
SF.Net email is sponsored by:
Tame your development challenges with Apache's Geronimo App Server. Download
it for free - -and be entered to win a 42" plasma tv or your very own
Sony(tm)PSP.  Click here to play: http://sourceforge.net/geronimo.php
