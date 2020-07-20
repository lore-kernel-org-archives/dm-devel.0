From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH 00/42] multipath-tools series part III:
	duplicate alias
Date: Mon, 20 Jul 2020 15:30:23 -0500
Message-ID: <20200720203023.GC11089@octiron.msp.redhat.com>
References: <20200709103513.8142-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200709103513.8142-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Disposition: inline
To: mwilck@suse.com
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Thu, Jul 09, 2020 at 12:35:10PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> Hi Christophe, hi Ben,
> 
> This is part II of a larger patch series for multpath-tools I've been preparing.
> It contains fixes for a customer issue where the same alias was set for
> several maps with different WWIDs in the WWIDs file.
> 
> It's based on the previously submitted part II.
> 
> The full series will also be available here:
> https://github.com/mwilck/multipath-tools/tree/ups/submit-2007
> 
> There are tags in that repo for each part of the series.
> This part is tagged "submit-200709-3".

With the first two of these patches applied , multipathd fails a
real-world situation in different, arguably worse, way than it currently
does, and I think it could do better.  If user_friendly_names is set,
but two (or more) devices weren't in the initramfs bindings file, they
will get random aliases during boot.  Assuming the devices are in the
regular filesystem bindings file, it's not super uncommon for these
devices to pick from the same alias as they use in the regular bindings
file, but with different wwids matching to different aliases.

Without these patches, multipath will rename them if possible, but if
not, they will still exist, but with the wrong alias. Existing with the
wrong alias isn't great, since things could be checking for the devices
by name, which could cause corruption. But in reality, usually they are
referenced by Labels, which will still work (since most things are
designed to not expect persistent naming of devices).  However, with
this patches, some of the devices will be deleted, which avoids the
possiblity of corruption, but in practice usually is worse because
referencing devices by label already avoids the corruption problem. 

A better idea might simply be to fallback to using the WWID as an alias,
on the offending map.  This should avoid corruption, since unless
someone manually set the WWID as an alias in multipath.conf it should be
unique. But it won't cause an existing, and possibly necessary, device
to get deleted.

-Ben
 
> Regards,
> Martin
> 
> Martin Wilck (3):
>   libmultipath: refuse creating map with duplicate alias
>   libmultipath: refuse reloading an existing map with different WWID
>   libmultipath: dm_addmap(): refuse creating map with empty WWID
> 
>  libmultipath/configure.c   | 24 ++++++++++++++++++++----
>  libmultipath/devmapper.c   | 26 +++++++++++++++-----------
>  libmultipath/structs_vec.c | 13 +++++++++++++
>  libmultipath/structs_vec.h |  1 +
>  multipathd/main.c          |  6 +++++-
>  5 files changed, 54 insertions(+), 16 deletions(-)
> 
> -- 
> 2.26.2
