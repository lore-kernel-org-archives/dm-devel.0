From: "Scott Moseman" <scmoseman@gmail.com>
Subject: Re: failover vs multibus
Date: Wed, 21 Nov 2007 08:54:30 -0600
Message-ID: <342d47870711210654g1412688anab2056de627c7c3d@mail.gmail.com>
References: <342d47870711200619u13d3a960see0d0cf5e65326bf@mail.gmail.com>
	<4742EFE6.6030808@linpro.no>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4742EFE6.6030808@linpro.no>
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Nov 20, 2007 8:32 AM, Tore Anderson <tore@linpro.no> wrote:
>
> > Re: default_path_grouping_policy in multipath.conf
> >
> > failover = 1 path per priority group
> > multibus = all valid paths in 1 priority group
> >
> > Does this mean that if I'm using failover I'm not going to get
> > multiple path throughput?  And, on the flip side, if I'm sending data
> > through multiple paths I'm not going to get failover support?
>
> Correct, and incorrect.  With "failover" topology only one path will be
> used at a time.  With "multibus" all of them will be - but failing paths
> _will not_ be used.  So if you have eight paths to your storage and are
> using multibus topology, load will be balanced over all eight paths.  If
> one fails, load will be balanced over the remaining seven.  And if you
> fix the failed path I/O will be balanced over all eight again.
>
> There's also the group_by_prio or group_by_serial topologies which is
> normally used in setups with an active/passive controller pair (most
> midrange gear are built in this way).  In this case I/O is load balanced
> over all the paths to the primary controller of a volume only, while the
> remaining paths (usually to a standby controller) will only be used if
> all (or enough) of the primary paths fail.
>

Hey Tore,

I tested a 'multibus' config and it performs just as I'm hoping!  :)

Thanks!
Scott
