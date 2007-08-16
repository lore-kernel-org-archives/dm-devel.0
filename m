From: "Stefan Bader" <Stefan.Bader@de.ibm.com>
Subject: Re: Designing a new prio_callout
Date: Thu, 16 Aug 2007 12:58:21 +0200
Message-ID: <5201e28f0708160358h15124fb5u836b1700b8b823c7@mail.gmail.com>
References: <d61540a40706211442w1ef3bacflddd44f74c8883a3f@mail.gmail.com>
	<46A735E1.4070206@suse.de>
	<d61540a40707290903q359cc7c8g52f07627b4b9fba7@mail.gmail.com>
	<46AD85A5.1060609@suse.de>
	<d61540a40708091055u725fa5e4wa182ac1d778323be@mail.gmail.com>
	<46BC7F14.80302@suse.de>
	<d61540a40708100840m541e198dg88c12d031febf968@mail.gmail.com>
	<d61540a40708141005n4eb06cebx14559f055b0df3d6@mail.gmail.com>
	<5201e28f0708150145s42ff46a5t8dab865931cb09d@mail.gmail.com>
	<d61540a40708150857v3182b221sa0c91d0cf90fd162@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <d61540a40708150857v3182b221sa0c91d0cf90fd162@mail.gmail.com>
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

> Now what happens? If mytarget has multiple LUs associated with it, the
> multipath output will look like it did below if failover is being used --
> two paths for each of two devices. The problem for us is that by default,
> multipath just uses the first path that it sees. Which means that for every
> device in mytarget, all data will be read and written across just the first
> path -- 10.53.151.22, in this case.
>
> We need a way to load balance connections across all available connections.
>
> There are several ways that I can see to do this. Ideally, we would
> implement ALUA on our end and advise people to use mpath_prio_alua as their
> callout. But this has a development cost. We could also implement a custom
> system as your suggest, but this also has a development cost.
>
> If we could advise users to manually set priorities on the client side, that
> would be acceptable, but this is impossible with the current version of
> multipath.
>

Can you find the IP address and UID of a device with the node name?
For example you get /dev/sdc and then look for UID (can be retrieved
with scsi_id) and the IP address of the connection (not sure this is
possible). Then manually create a file containing mappings:

<uid>:<ip>:<priority>
...

Create a script that is used as the callout which takes a node name
looks into the file and prints out the priority. This way the priority
of a path does not change like it does with random priorities. The
other path will only be used on failure and switched back as soon as
the other one is back again (with failback immediate).


> On a related note, I've read the reports of people experiencing higher
> levels of performance with lower settings of rr_min_io, but it seems to me
> that as rr_min_io gets smaller, the system becomes less like active/passive
> MPIO and more like active/active MPIO, so users experiencing this
> performance improvement would be better off using group_by_serial, so that
> all paths are excitable simultaneously.
>

The setting of rr_min_io only matters if you have more than one path
per path group. Otherwise  you only can use one path at a time and
there is no round-robin. If you have more than one path in a group
then lower values help since paths are more likely to be used
concurrently. The default of 1000 is to high. Kiyoshi Ueda and
Jun'ichi Nomura have done some measurements while looking for a way to
improve performance more generally
(https://ols2006.108.redhat.com/2007/Reprints/ueda-Reprint.pdf). But
again, rr_min_io is only relevant to load-balance paths within the
same path group (multibus or as you mentioned group_by_serial). The
reason for you path changes (except for real failures) might be rather
that random_prio results in different priorities whenever any priority
value is checked again.

Stefan
