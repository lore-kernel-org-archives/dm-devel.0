From: Heinz Mauelshagen <mauelshagen@redhat.com>
Subject: [mauelshagen@redhat.com: Re: RAID5 support ?]
Date: Tue, 25 Oct 2005 19:34:14 +0200
Message-ID: <20051025173414.GF3500@redhat.com>
Reply-To: mauelshagen@redhat.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
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
Cc: hjm@redhat.com
List-Id: dm-devel.ids


Hrm, posted to wrong list ;)

----- Forwarded message from Heinz Mauelshagen <mauelshagen@redhat.com> -----

X-Sieve: CMU Sieve 2.2
Date: Tue, 25 Oct 2005 19:04:44 +0200
From: Heinz Mauelshagen <mauelshagen@redhat.com>
To: ataraid-list@redhat.com
Cc: hjm@redhat.com
Subject: Re: [dm-devel] RAID5 support ?
Reply-To: mauelshagen@redhat.com
In-Reply-To: <62b0912f0510250812l3a9ab85bo7887fc07b9c5cb44@mail.gmail.com>
User-Agent: Mutt/1.4.1i
X-Sender: mauelshagen@RedHat.com

On Tue, Oct 25, 2005 at 05:12:53PM +0200, Molle Bestefich wrote:
> Heinz Mauelshagen wrote:
> > FYI: we keep information about which regions (arbitrary sized segments
> >      of the address space) of the set are dirty with the the
> >      device-mapper dirty-log so that we can resynchonize those at set startup.
> 
> Sounds sort of nasty.
> What happens if the user boots to Windows in the mean time?
> Windows will see corrupted data?

Molle,

that was a general statement about device-mapper, not how I use
it with dmraid. dmraid relies on the simple ATARAID metadata which
essentially keeps a clean/dirty flag for the whole set.

Sorry for being unclear,
Heinz

> 
> (I mean, that's the whole point of using a hardware soft-RAID
> solution, isn't it?  BIOS and multiple-OS support for the metadata
> format / RAID arrays?)

=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

Heinz Mauelshagen                                 Red Hat GmbH
Consulting Development Engineer                   Am Sonnenhang 11
Cluster and Storage Development                   56242 Marienrachdorf
                                                  Germany
Mauelshagen@RedHat.com                            +49 2626 141200
                                                       FAX 924446
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

----- End forwarded message -----
