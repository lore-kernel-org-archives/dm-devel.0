From: Peter Rajnoha <prajnoha@redhat.com>
Subject: Re: [PATCH] libdm: add "|" to _is_whitelisted_char()
Date: Wed, 28 Nov 2012 13:50:39 +0100
Message-ID: <50B6089F.6040603@redhat.com>
References: <20121127191123.GZ19704@osdn.org.ua> <50B5FDCD.2030605@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <50B5FDCD.2030605@redhat.com>
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
Cc: Sergey Vlasov <vsu@altlinux.ru>, Michael Shigorin <mike@osdn.org.ua>, "Dmitry V. Levin" <ldv@altlinux.org>
List-Id: dm-devel.ids

On 11/28/2012 01:04 PM, Peter Rajnoha wrote:
> Now, if you *really* intend to bypass this mangling and udev,
> you can use:
> 
>   dmsetup <dm_command> --manglename none ...
> 

If you use libdevmapper to handle device-mapper devices, have
a look at libdevmapper.h. You can bypass default mangling with
dm_set_name_mangling_mode(DM_STRING_MANGLING_NONE):

---
/*
 * Mangling support
 *
 * Character whitelist: 0-9, A-Z, a-z, #+-.:=@_
 * HEX mangling format: \xNN, NN being the hex value of the character.
 * (whitelist and format supported by udev)
*/
typedef enum {
        DM_STRING_MANGLING_NONE, /* do not mangle at all */
        DM_STRING_MANGLING_AUTO, /* mangle only if not already mangled with hex, error when mixed */
        DM_STRING_MANGLING_HEX   /* always mangle with hex encoding, no matter what the input is */
} dm_string_mangling_t;

/*
 * Set/get mangling mode used for device-mapper names and uuids.
 */
int dm_set_name_mangling_mode(dm_string_mangling_t name_mangling);
dm_string_mangling_t dm_get_name_mangling_mode(void);
---

Peter
