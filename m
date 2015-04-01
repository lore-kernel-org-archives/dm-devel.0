From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH 1/7] lib/vsprintf: add %*pg format specifier
Date: Wed, 01 Apr 2015 11:43:35 +0300
Message-ID: <87r3s4tf0o.fsf@openvz.org>
References: <1427817681-4494-1-git-send-email-dmonakhov@openvz.org> <1427817681-4494-2-git-send-email-dmonakhov@openvz.org> <1427821576.10376.29.camel@perches.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha512; protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1427821576.10376.29.camel@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, axboe@kernel.dk, viro@zeniv.linux.org.uk, dm-devel@redhat.com
List-Id: dm-devel.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Joe Perches <joe@perches.com> writes:

> On Tue, 2015-03-31 at 20:01 +0400, Dmitry Monakhov wrote:
>> This allow to directly print block_device name.
>> Currently one should use bdevname() with temporal char buf[BDEVNAME_SIZE=
].
>> This is very ineffective because bloat stack usage for deep IO call-trac=
es
> []
>> diff --git a/lib/vsprintf.c b/lib/vsprintf.c
> []
>> @@ -610,6 +613,23 @@ char *dentry_name(char *buf, char *end, const struc=
t dentry *d, struct printf_sp
>>  	return buf;
>>  }
>>=20=20
>> +#ifdef CONFIG_BLOCK
>> +static noinline_for_stack
>> +char *bdev_name(char *buf, char *end, struct block_device *bdev,
>> +		struct printf_spec spec, const char *fmt)
>> +{
>> +	struct gendisk *hd =3D bdev->bd_disk;
>
> Can you please use the same form as dentry_name and
> dereference the pointer in vsprintf not here as below.
Im not sure I've got your comments. Please elaborate.
As far as I can see vsprintf->pointer looks like follows:
       dentry_name
        case 'd':
                        return dentry_name(buf, end, ptr, spec, fmt);
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
No any special dereference logic here. Later dentry ptr dereferenced
and accessed inside dentry_name as usual. Same logic works for Ipv[46]
format specifiers.

***Copied comment from next email:
>   Perhaps it would be useful to update the disk_name/bdevname
>   functions to take a buffer length along with the char * so
>   that buffer overflows could not occur.
disk_name() use snprintf which is bad candidate to use inside vsprintf.
>
>   That would also allow this function to use bdevname directly.
I'll change bdevname() to use "%pg" format specifier in order to
eliminate code duplication.
>
>> @@ -1404,6 +1424,8 @@ int kptr_restrict __read_mostly;
>>   *           (default assumed to be phys_addr_t, passed by reference)
>>   * - 'd[234]' For a dentry name (optionally 2-4 last components)
>>   * - 'D[234]' Same as 'd' but for a struct file
>> + * - 'g' For block_device name (gendisk + partition number)
>> +
>>   *
>>   * Note: The difference between 'S' and 'F' is that on ia64 and ppc64
>>   * function pointers are really function descriptors, which contain a
>> @@ -1552,6 +1574,11 @@ char *pointer(const char *fmt, char *buf, char *e=
nd, void *ptr,
>>  		return dentry_name(buf, end,
>>  				   ((const struct file *)ptr)->f_path.dentry,
>>  				   spec, fmt);
>> +#ifdef CONFIG_BLOCK
>> +	case 'g':
>> +		return bdev_name(buf, end, ptr, spec, fmt);
>> +#endif
>> +
>>  	}

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBCgAGBQJVG6+3AAoJELhyPTmIL6kBCeIH/igzhRg/F6y/Uy73gzfnT2M8
/L1LHKqKtkj04pha6zd2uXRt4vd0lNxFCgE5sgY1G6em2Gw4/cNXRS+wuhH1fZC8
aA7wGseBb5gFz4YCTa2ZOOGLFqyLOF3SyHwAI+vjCiKtjy9KxRcRt5/PGWKFbv+A
voB0oAkQ5Wh6qRwo3uyPtU49WDXE4oafB4n5pq8FCNWGhKHnYLqFD5L1aUHu6G5X
691ONN1mNALraE6CSeoFXBbPPqcEk87kMcMgk75DxPN0cu3cvRNVdFsGTJ2cFg+n
SKx2jq+aLO2yHHeyMpXgXdu3egaYn84BaQ7b3AZ6gXSglQvBGut5yN7sAMtcoVk=
=wFVj
-----END PGP SIGNATURE-----
--=-=-=--
