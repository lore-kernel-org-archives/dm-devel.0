From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 3/3] multipath: implement controller framework
	for hardware handlers (fwd)
Date: Mon, 19 Nov 2007 15:00:08 +0100
Message-ID: <474196E8.5020503@suse.de>
References: <alpine.LFD.0.9999.0711190838370.3253@localhost.localdomain>
	<alpine.LFD.0.9999.0711190838590.3253@localhost.localdomain>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LFD.0.9999.0711190838590.3253@localhost.localdomain>
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

Chip Coldwell wrote:
> From: Hannes Reinecke <hare@suse.de>
> diff --git a/drivers/md/dm-hw-handler.h b/drivers/md/dm-hw-handler.h
>> index 9216682..6f91b55 100644
>> --- a/drivers/md/dm-hw-handler.h
>> +++ b/drivers/md/dm-hw-handler.h
>> @@ -15,10 +15,31 @@
>> =20
>>  struct hw_handler_type;
>> =20
>> +#define CTLR_ID_LEN 256
>> +
>> +struct hw_controller {
>> +	struct list_head node;
>> +	struct hw_controller_type *type;
>> +	unsigned char ctlr_id[CTLR_ID_LEN];
>> +	struct kref kref;
>> +	spinlock_t lock;
>> +	struct list_head cmd_list;
>> +	int submitted;
>> +	void *context;
>> +};
>> +
>> +struct hw_controller_type {
>> +	char *name;
>> +
>> +	int (*create) (struct hw_controller *ctlr);
>> +	void (*destroy) (struct hw_controller *ctlr);
>> +};
>> +
>=20
> Would it make sense to make hw_controller_type a kobj_type?  That way,
> the controller topology could be reflected in sysfs, where it can be
> reached by tools such as lsscsi.
>=20
Eventually, maybe.

Plan is to add userland support to manually declare and assign
controller to each priority group.
But I haven't really sorted out the details there (how to pass
information etc) and I really would like to have the basic
infrastructure agreed upon first.
And implementing a kobj_type at this point would be a bit
over the top as we are in the very preliminary stages here.

Once the controller framework is accepted we can think about it.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
