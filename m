From: Stephen Smalley <stephen.smalley@gmail.com>
Subject: Re: [RFC] IMA: New IMA measurements for dm-crypt and selinux
Date: Sat, 11 Apr 2020 15:05:07 -0400
Message-ID: <CAB9W1A1=JyOV3-+6jn3xX-M+GKWBB2cCNh-VWB_kzf+YiR_d2Q@mail.gmail.com>
References: <f92bef0f-eb40-0e07-540c-321134e4b070@linux.microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <f92bef0f-eb40-0e07-540c-321134e4b070@linux.microsoft.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Tushar Sugandhi <tusharsu@linux.microsoft.com>
Cc: linux-integrity@vger.kernel.org, Mimi Zohar <zohar@linux.ibm.com>, LSM List <linux-security-module@vger.kernel.org>, SELinux <selinux@vger.kernel.org>, dm-devel@redhat.com, James Morris <jmorris@namei.org>, chpebeni@linux.microsoft.com, nramas@linux.microsoft.com, balajib@microsoft.com, sashal@kernel.org, suredd@microsoft.com
List-Id: dm-devel.ids

On Wed, Apr 8, 2020 at 6:28 AM Tushar Sugandhi
<tusharsu@linux.microsoft.com> wrote:
> Measuring SELinux status and various SELinux policies can help ensure
> mandatory access control of the system is not compromised.
<snip>
> B. Measuring selinux constructs:
>      We propose to add an IMA hook in enforcing_set() present under
>      security/selinux/include/security.h.
>      enforcing_set() sets the selinux state to enforcing/permissive etc.
>      and is called from key places like selinux_init(),
>      sel_write_enforce() etc.
>      The hook will measure various attributes related to selinux status.
>      Majority of the attributes are present in the struct selinux_state
>      present in security/selinux/include/security.h
>      e.g.
>      $sestatus
>             SELinux status:              enabled
>             SELinuxfs mount:             /sys/fs/selinux
>             SELinux root directory:      /etc/selinux
>             Loaded policy name:          default
>             Current mode:                permissive
>             Mode from config file:       permissive
>             Policy MLS status:           enabled
>             Policy deny_unknown status:  allowed
>             Memory protection checking:  requested (insecure)
>             Max kernel policy version:   32
>
>      The above attributes will be serialized into a set of key=value
>      pairs when passed to IMA for measurement.
>
>      Proposed Function Signature of the IMA hook:
>      void ima_selinux_status(void *selinux_status, int len);

This won't detect changes to any of these state variables via a kernel
write vulnerability,
so it would be good to provide a way to trigger measurement of the
current values on
demand.
You'll also likely want to measure parts of the child structures of
selinux_state, e.g. selinux_ss,
especially selinux_map and policydb.  You can simplify measurement of
the policydb by
serializing it first via policydb_write() and hashing the result. I
suppose one question is whether you can do all of this
already from userspace by just having userspace read
/sys/fs/selinux/enforce, /sys/fs/selinux/policy, etc.
