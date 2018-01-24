From: Wuchongyun <wu.chongyun@h3c.com>
Subject: Re: [PATCH] multipath-tools:fix unexport/export LUN
 access permission multipath can't restore
Date: Wed, 24 Jan 2018 06:07:04 +0000
Message-ID: <CEB9978CF3252343BE3C67AC9F0086A3429589B7@H3CMLB14-EX.srv.huawei-3com.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: zh-CN
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Changwei Ge <ge.changwei@h3c.com>, Benjamin Marzinski <bmarzins@redhat.com>, Hannes Reinecke <hare@suse.de>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>, Guozhonghua <guozhonghua@h3c.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Changlimin <changlimin@h3c.com>, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

Hi Hannes and Ben's,
Thanks for your comments! We are agree with you.
It is truly have the potential risk even we trigger an event to =

fresh udev database and continue to use this multipath but =

it seems to be not really safe in this way.

-----original-----
Hi Ben,

On 2018/1/23 21:03, Benjamin Marzinski wrote:
> On Tue, Jan 23, 2018 at 10:52:35AM +0100, Hannes Reinecke wrote:
>> On 01/23/2018 10:25 AM, Wuchongyun wrote:
>>> Hi Christophe, Hannes, Martin, Xose and Benjamin,
>>>
>>> We meet below issue when doing the unexport/export LUN's access permiss=
ion test, this patch is a method to fix this issue.
>>> If it is convenient for some of you, please help to review this patch, =
thanks.
>>>
>>> fix unexport/export LUN access permission multipath can't restore
>>>
>>> Issue:
>>> (1)Export LUN1 to host1,Create multipath, LUN1 have two paths: sda =

>>> and sdb; (2)Unexport LUN1 to host1, host1 can't access LUN1.Kernel =

>>> produce change uevent for sda and sdb, then uev_update_path been =

>>> called, which will found the path's wwid have changed and set flag =

>>> pp->wwid_changed , checker thread's check_path() found this flag =

>>> will set those paths failed and report to DM, and then this =

>>> multipath failed.
>>> (3)export LUN1 to host1 again. Kernel produce the change uevents, =

>>> but those uevents are not belong to LUN1(not sda and sdb).
>>> So LUN1's related devices' status(wwid) not been updated by uevent =

>>> when regain this LUN's permission and this multipath will not restore a=
nymore.
>>>
>>> Through some experiments we found that:
>>> unexport/export LUN to host, kernel may not produce the change =

>>> uevent for the right devices. It may be other devices, and the =

>>> result may different.
>>> Get wwid by "/lib/udev/scsi_id --whitelisted --device=3D/dev/%n"will =

>>> always get the latest wwid: when no access permission return a =

>>> invalid wwid, when access restore return the origial right wwid.
>>>
>>> If we meet this situation above issue will happen:
>>> when unexporting LUN we get the right change uevent and refresh this =

>>> path's wwid to a valid value(HP 3PAR is 30000000000000000); When =

>>> exporting LUN to the host again we get the other devices' change =

>>> uevents, then we have no chance to refresh the changed paths'wwid, =

>>> and this multipath will not restore even it's LUN access permissions =

>>> have been restored.
>>>
>>> This patch can fix this issue by:
>>> In check_path() if found flag pp->wwid_changed is set, compare the =

>>> wwid gotten by scsi_id and the wwid gotten by udev(current get_uid). =

>>> If the value is not equal, it most likely we got the access =

>>> permissions or device valid again, scsi_id's wwid may restored, we =

>>> should produce a change uevent to fresh this device's status.
>>>
>>> Signed-off-by: Chongyun Wu <wu.chongyun@h3c.com>
>>> ---
>>>   libmultipath/defaults.h |    1 +
>>>   multipathd/main.c       |   51 ++++++++++++++++++++++++++++++++++++++=
+++++++++
>>>   2 files changed, 52 insertions(+)
>>>
>>> diff --git a/libmultipath/defaults.h b/libmultipath/defaults.h index =

>>> c9e3411..895d3a1 100644
>>> --- a/libmultipath/defaults.h
>>> +++ b/libmultipath/defaults.h
>>> @@ -3,6 +3,7 @@
>>>    * and the TEMPLATE in libmultipath/hwtable.c
>>>    */
>>>   #define DEFAULT_UID_ATTRIBUTE	"ID_SERIAL"
>>> +#define DEFAULT_GETUID		"/lib/udev/scsi_id --whitelisted --device=3D/d=
ev/%n"
>>>   #define DEFAULT_UDEVDIR		"/dev"
>>>   #define DEFAULT_MULTIPATHDIR	"/" LIB_STRING "/multipath"
>>>   #define DEFAULT_SELECTOR	"service-time 0"
>>> diff --git a/multipathd/main.c b/multipathd/main.c index =

>>> 27cf234..dedc7d2 100644
>>> --- a/multipathd/main.c
>>> +++ b/multipathd/main.c
>>> @@ -937,6 +937,9 @@ uev_update_path (struct uevent *uev, struct vectors=
 * vecs)
>>>   	if (pp) {
>>>   		struct multipath *mpp =3D pp->mpp;
>>>   =

>>> +		udev_device_unref(pp->udev);
>>> +		pp->udev =3D udev_device_ref(uev->udev);
>>> +
>>>   		if (disable_changed_wwids &&
>>>   		    (strlen(pp->wwid) || pp->wwid_changed)) {
>>>   			char wwid[WWID_SIZE];
>>> @@ -1578,6 +1581,54 @@ check_path (struct vectors * vecs, struct path *=
 pp, int ticks)
>>>   		condlog(2, "%s: path wwid has changed. Refusing to use",
>>>   			pp->dev);
>>>   		newstate =3D PATH_DOWN;
>>> +
>>> +		/*
>>> +		 * compare the wwid gotten form scsi_id with the wwid which
>>> +		 * gotten form udev. maybe the path wwid have been restored
>>> +		 * by LUN been exported to the host again or another
>>> +		 * operations making the wwid different form udev database.
>>> +		 * If so, should trigger change uevent to refresh this
>>> +		 * path's udev datebase.
>>> +		*/
>>> +		char wwid_old[WWID_SIZE];
>>> +		char wwid_form_scsi_id[WWID_SIZE];
>>> +		char wwid_form_udev[WWID_SIZE];
>>> +		char buff[CALLOUT_MAX_SIZE];
>>> +		char *getuid_old =3D NULL;
>>> +
>>> +		memset(wwid_form_scsi_id, 0, WWID_SIZE);
>>> +		memset(wwid_form_udev, 0, WWID_SIZE);
>>> +
>>> +		/* save this path's  wwid and getuid*/
>>> +		strcpy(wwid_old, pp->wwid);
>>> +		if (pp->getuid) {
>>> +			getuid_old =3D buff;
>>> +			strcpy(getuid_old, pp->getuid);
>>> +		}
>>> +
>>> +		/* using /lib/udev/scsi_id to get wwid */
>>> +		pp->getuid =3D DEFAULT_GETUID;
>>> +		get_uid(pp, PATH_UP, pp->udev);
>>> +		strcpy(wwid_form_scsi_id, pp->wwid);
>>> +		/* using udev to get wwid */
>>> +		pp->getuid =3D NULL;
>>> +		get_uid(pp, PATH_UP, pp->udev);
>>> +		strcpy(wwid_form_udev, pp->wwid);
>>> +
>>> +		if (0 !=3D strcmp(wwid_form_scsi_id, wwid_form_udev)) {
>>> +			sysfs_attr_set_value(pp->udev, "uevent", "change",
>>> +				strlen("change"));
>>> +			condlog(2, "%s: wwid inconsistent triggering change "
>>> +				"event to refresh udev database", pp->dev);
>>> +		}
>>> +
>>> +		/* change this path's wwid and getuid back*/
>>> +		strcpy(pp->wwid, wwid_old);
>>> +		if (getuid_old) {
>>> +			strcpy(pp->getuid, getuid_old);
>>> +		} else {
>>> +			pp->getuid =3D getuid_old;
>>> +		}
>>>   	}
>>>   =

>>>   	if (newstate =3D=3D PATH_WILD || newstate =3D=3D PATH_UNCHECKED) {
>>>
>> NAK.
>>
>> We currently don't handle WWID change / LUN mapping changes correctly =

>> from the linux kernel; the only way to correctly instantiate this is =

>> to remove the device from sysfs and rescan the host.
>> Everything else will result in partially stale values for the device, =

>> and an incorrect operation.
>> This is not something you can 'fix' on the multipath level.
> =

> Yes. The only safe thing to do when we notice this is disable access =

> to the device. This is what the disable_changed_wwids option. If we =

> see the same wwid, then it might make sense to update the udev device, =

> but if the wwid has changed, then we must assume that our device got =

> remapped underneath us, and we can't handle that.

Thanks for your clue. That's very helpful to us. :-)

Changwei

> =

> -Ben
>   =

>> Cheers,
>>
>> Hannes
>> -- =

>> Dr. Hannes Reinecke		   Teamlead Storage & Networking
>> hare@suse.de			               +49 911 74053 688
>> SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
>> GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton HRB =

>> 21284 (AG N=FCrnberg)
> =
