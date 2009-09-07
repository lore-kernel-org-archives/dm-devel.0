From: "Chauhan, Vijay" <Vijay.Chauhan@lsi.com>
Subject: RE: Re: [RFC] New  Logging approach for Device Mapper
Date: Mon, 7 Sep 2009 12:58:43 +0530
Message-ID: <0D1E8821739E724A86F4D16902CE275C1C8EAE09BF@inbmail01.lsi.com>
References: <20090905233331.GB2518@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090905233331.GB2518@agk-dp.fab.redhat.com>
Content-Language: en-US
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
Cc: "Dachepalli, Sudhir" <Sudhir.Dachepalli@lsi.com>, "Stankey,
	Robert" <Robert.Stankey@lsi.com>, "Moger, Babu" <Babu.Moger@lsi.com>
List-Id: dm-devel.ids

On Sun, Sep 6, 2009 at 5:03 AM, Alasdair G Kergon <agk@redhat.com> wrote:
> > Each logging type is represented with 2 bits in=20
> dm_logging_level. Following are the logging types currently defined :
>=20
> Does that mean there's a limit we'll soon exceed?

Yes true. In that case we can further split the logging across the target=
s , such as multipath, linear so on. Your thoughts please.

>=20
> > Sep  5 18:32:02 localhost kernel: device-mapper: core:=20
> DEBUG: dm_resume: Unsetting DMF_SUSPENDED flag for 253:1
>=20
> I was hoping the next extension to the macro code would=20
> somehow add info
> like '253:1' (and maybe corresponding device name) automatically to
> every message related to a device.
>=20

Ok. I will so that.

>=20
> But do we really need this level of runtime debugging configurability?
> I can't say I've come across problems where I'd have needed it: Can=20
> anyone else offer examples where it would have helped them?
>=20

Both approaches ("without level" and "with level") looks fine to me. Adva=
ntage with going for "Without level" approach is that we will be having f=
urther more space for defining log types.=20

Advantage with "with level" approach is that it will log more relevant lo=
gs. Just giving a hypothetical example here, Lets assume I/O getting kill=
ed during all path failure condition when no_path_retry feature was set. =
To debug that I may want to check what all messages communicated from use=
rspace to kernel. Also I may want to check DM_NOFLUSH_FLAG being set prop=
erly here. For the same I would set following log levels:

---------------------------
LOG TYPES		LOG LEVEL
----------------------------
DM_IOCTL		DM_INFO       --> It will print all the communication between u=
serspace and kernel space
DM_IO			DM_ERR        --> It will tell exactly where I/O error was hit.


"without level" approach in this scenario will log more messages here in =
comparison.

Third approach I could think of it is having flexible level. i.e we can i=
gnore levels for those types which populates syslog less(such as DM_INIT,=
 DM_FAILOVER ..) and can have levels for those which are logging heavily =
(such as DM_IO, DM_IOCTL .. ). But it may add some complexity in calculat=
ing and setting the log levels.=20

Your thoughts.

Thanks,
Vijay
