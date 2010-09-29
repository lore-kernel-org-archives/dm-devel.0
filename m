From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] dm-thinp: new device mapper target to thin
 provision storage
Date: Wed, 29 Sep 2010 08:29:34 +0200
Message-ID: <4CA2DCCE.3070905@suse.de>
References: <1285706977.22966.20.camel@o> <4CA261C5.7070005@cfl.rr.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4CA261C5.7070005@cfl.rr.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: heinzm@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

Phillip Susi wrote:
> On 9/28/2010 4:49 PM, Heinz Mauelshagen wrote:
>> These are 2 new device mapper targets "thinp" and "thinp-dev"
>> implemented in one module, which allow for thin provisioning of storage
>> on a single host from a storage pool to an arbitrary amount of devices.
> =

> How is this different than snapshotting a zero target?
> =

Main difference is that you actually can free up space.
You can't with snapshotting as then a rollback
becomes impossible.

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
