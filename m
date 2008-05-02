From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] Don't print failure messages for callouts
	by default
Date: Fri, 02 May 2008 08:55:11 +0200
Message-ID: <481ABACF.1000808@suse.de>
References: <20080430090426.D2B4718C6FF@pentland.suse.de>
	<20080430.185337.115902447.k-ueda@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20080430.185337.115902447.k-ueda@ct.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: dm-devel@redhat.com, christophe.varoqui@free.fr
List-Id: dm-devel.ids

Kiyoshi Ueda wrote:
> Hi Hannes,
>=20
> On Wed, 30 Apr 2008 11:04:26 +0200, hare@suse.de (Hannes Reinecke) wrot=
e:
>> Calling 'multipath -ll' on devices with paths results in
>> lots of error messages; they really should be suppressed
>> for the normal output. The user can always have them printed
>> out by increasing verbosity.
>=20
> In general, serious error messages should be printed by default.
> Otherwise, the users (even developers) may overlook serious errors.
>=20
Agreed in principle. However, most of these error messages are secondary
messages (ie the are generated after the principal cause was reported)
so they do not carry any additional information to the 'normal' user.

Case in point here is for a path failure: this is multipathing, after all=
,
the whole point of which is that we _can_ handle path failure seamlessly.
So throwing error messages for a perfectly normal flow of operation is
really confusing.

> Please see the detailed comments below.
> =20
>> @@ -32,7 +33,7 @@ int execute_program(char *path, char *value, int len=
)
>>  	int retval;
>>  	int count;
>>  	int status;
>> -	int fds[2];
>> +	int fds[2], null_fd;
>>  	pid_t pid;
>>  	char *pos;
>>  	char arg[PROGRAM_SIZE];
>> @@ -75,7 +76,16 @@ int execute_program(char *path, char *value, int le=
n)
>>  		close(STDOUT_FILENO);
>> =20
>>  		/* dup write side of pipe to STDOUT */
>> -		dup(fds[1]);
>> +		if (dup(fds[1]) < 0)
>> +			return -1;
>> +
>> +		/* Ignore writes to stderr */
>> +		null_fd =3D open("/dev/null", O_WRONLY);
>> +		if (null_fd > 0) {
>> +			close(STDERR_FILENO);
>> +			dup(null_fd);
>> +			close(null_fd);
>> +		}
>> =20
>>  		retval =3D execv(argv[0], argv);
>> =20
>=20
> This looks discarding all error messages from callouts anyway,
> even if we want to get them.
> Can you use the verbosity setting here, too?
>=20
Yes, we could; no problem.

>=20
>> @@ -642,7 +642,7 @@ get_prio (struct path * pp)
>>  	}
>>  	pp->priority =3D prio_getprio(pp->prio, pp);
>>  	if (pp->priority < 0) {
>> -		condlog(0, "%s: %s prio error", pp->dev, prio_name(pp->prio));
>> +		condlog(3, "%s: %s prio error", pp->dev, prio_name(pp->prio));
>>  		pp->priority =3D PRIO_UNDEF;
>>  		return 1;
>>  	}
>=20
> When prio_getprio() fails, that path is not used for multipath.
> I think that it is a kind of serious error and the verbosity should
> be "2" at least.
>=20
> Why do you need to suppress this message by default?
>=20
Because the prioritizer also will fail if a path failed. In this case
you get quite some errors like 'prio_alua failed' on a failed path,
inducing you to check if the prio_alua program might be wrong.
In fact, everything is alright and working as expected, only
that a path has failed.
So this error message might a well be suppressed.

>=20
>> @@ -663,7 +663,7 @@ get_uid (struct path * pp)
>>  		condlog(0, "error formatting uid callout command");
>>  		memset(pp->wwid, 0, WWID_SIZE);
>>  	} else if (execute_program(buff, pp->wwid, WWID_SIZE)) {
>> -		condlog(0, "error calling out %s", buff);
>> +		condlog(3, "error calling out %s", buff);
>>  		memset(pp->wwid, 0, WWID_SIZE);
>>  		return 1;
>>  	}
>=20
> ditto.
>=20
Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
