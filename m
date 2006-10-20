From: Dave Wysochanski <dave.wysochanski@redhat.com>
Subject: Re: [PATCH RFC] replace dm hw handlers with scsi handlers
Date: Thu, 19 Oct 2006 20:40:15 -0400
Message-ID: <1161304816.4770.1.camel@linux-cxyg.rtp.netapp.com>
References: <1160684310.4163.4.camel@madmax> <4530E19A.8040002@cs.wisc.edu>
	<1161074225.6464.1.camel@localhost.localdomain>
	<20061018143324.GB25084@pentland.suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20061018143324.GB25084@pentland.suse.de>
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

On Wed, 2006-10-18 at 16:33 +0200, Hannes Reinecke wrote:
> Hi Mike,
>=20
> On Tue, Oct 17, 2006 at 10:37:05AM +0200, Christophe Varoqui wrote:
> > Le samedi 14 octobre 2006 =C3=A0 09:09 -0400, Mike Christie a =C3=A9c=
rit :
> > > Christophe V, I was wondering what is the vendor/module info for yo=
ur
> > > box? We have a MSA1000 VOLUME/COMPAQ here, but START_STOP does not
> > > work.
> > > I mean if I send the command it always executes successfully, but t=
he
> > > device does not failover (READ/WRITEs fail). I tried just running
> > > sg_start and this runs ok but READ/WRITE still fail, so I hacked up
> > > scsi_debug to simulate my testing.=20
> >=20
> > It was a HSG80 based array, namely a HP EMA8000.
> > I do not have access to this hardware anymore.
> >=20
>=20
> Hmm. Finally I got a MSA1000 here, too (Thanks, HP!). dm_hp_sw seems
> to work properly there. Note that according to the HP qla2xxx sources
> the MSA1000 might take some time to actually do the switchover.
> Appearently they return NOT_READY / UNIT_ATTENTION and some weird statu=
s
> in byte 12 & 13 of the sense buffer (!). So please check the sense code
> if there is anything untoward.
> Oh, and you can check whether the failover really occured by using
> the management console; 'show this_controller' and 'show other_controll=
er'
> will tell you which one's active.
> Drop me a mail if you got further questions.=20
>=20
> Apart from this: good work!
>=20

Hannes - did you run mike's code from his git tree or something else?

I'm confused by your reference to "dm_hp_sw".

Thanks.
