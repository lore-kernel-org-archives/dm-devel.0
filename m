From: "Wood, Brian J" <brian.j.wood@intel.com>
Subject: RE: [PATCH 1/2] add stripe end_io function and eventtrigger
Date: Wed, 5 Dec 2007 11:37:23 -0800
Message-ID: <D44F48C7D79D2943A073C8FA0F49A3CC01A56B34@orsmsx418.amr.corp.intel.com>
References: <D44F48C7D79D2943A073C8FA0F49A3CC01A1DFE8@orsmsx418.amr.corp.intel.com>
	<20071205175708.GA12022@linux.vnet.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <20071205175708.GA12022@linux.vnet.ibm.com>
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
Cc: Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Ah, ok. Thanks Mike I'll run that and repost. (Sorry for the error).



Brian Wood
Software Engineer
Intel Corp., Manageability & Platform Software Division
brian.j.wood@intel.com

>-----Original Message-----
>From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com]
On
>Behalf Of Mike Anderson
>Sent: Wednesday, December 05, 2007 9:57 AM
>To: device-mapper development
>Cc: Alasdair G Kergon
>Subject: Re: [dm-devel] [PATCH 1/2] add stripe end_io function and
>eventtrigger
>
>Wood, Brian J <brian.j.wood@intel.com> wrote:
>> +static void trigger_event(struct work_struct *work)
>> +{
>> +	int i, len;
>> +	char dev_path[DEV_STR_LEN];
>> +	struct stripe_c *sc =3D container_of(work, struct stripe_c,
>> kstriped_ws);
>
>It appears your mailer is breaking lines which leads to hand edits
prior
>to trying to apply the patch.
>
>Your patch also appears to be adding extra whitespace. You want to run
>checkpatch.pl prior to sending the patch out and correct all issues
>listed.
>
>> +		/* Finally as a last check, see if the inode mode is set
>>
>> +		 * to be a block device, record error if not */
>
>> +		if (!S_ISBLK(inode->i_mode)) {
>> +			atomic_inc(&(sc->stripe[i].error_count));
>> +		}
>
>Code comment style and extra bracing.
>
>http://sources.redhat.com/lvm2/wiki/KernelPatchGuidelines
>
>
>-andmike
>--
>Michael Anderson
>andmike@linux.vnet.ibm.com
>
>--
>dm-devel mailing list
>dm-devel@redhat.com
>https://www.redhat.com/mailman/listinfo/dm-devel
