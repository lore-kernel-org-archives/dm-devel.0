From: Tushar Sugandhi <tusharsu@linux.microsoft.com>
Subject: [RFC] IMA: New IMA measurements for dm-crypt and selinux
Date: Wed, 8 Apr 2020 03:19:38 -0700
Message-ID: <f92bef0f-eb40-0e07-540c-321134e4b070@linux.microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Language: en-US
Sender: owner-linux-security-module@vger.kernel.org
To: linux-integrity@vger.kernel.org, zohar@linux.ibm.com, linux-security-module@vger.kernel.org, selinux@vger.kernel.org, dm-devel@redhat.com
Cc: jmorris@namei.org, chpebeni@linux.microsoft.com, nramas@linux.microsoft.com, balajib@microsoft.com, sashal@kernel.org, suredd@microsoft.com
List-Id: dm-devel.ids

The goals of the kernel integrity subsystem are to detect if files have
been accidentally or maliciously altered, both remotely and locally,
appraise a file's measurement against a "good" value stored as an
extended attribute, and enforce local file integrity [1].

To achieve these goals, IMA subsystem measures several in-memory
constructs and files.

We propose to measure constructs in dm-crypt and selinux to further
enhance measuring capabilities of IMA.

If there is existing or planned work to measure dm-crypt and selinux
constructs, we would like to contribute to that.

dm-crypt is a subsystem used for encryption of the block device, which
is essential for ensuring protection of data and secrets at rest.

Measuring encryption status of the device will ensure the device is not
maliciously reporting false encryption status - thus, it can be
entrusted with sensitive data to be protected at rest.

SELinux is an implementation of mandatory access controls (MAC) on
Linux. Mandatory access controls allow an administrator of a system to
define how applications and users can access different resources - such
as files, devices, networks and inter-process communication. With
SELinux an administrator can differentiate a user from the applications
a user runs [2].

Measuring SELinux status and various SELinux policies can help ensure
mandatory access control of the system is not compromised.

Proposal:
---------
A. Measuring dmcrypt constructs:
     We can add an IMA hook in crypt_ctr() present in
     drivers/md/dm-crypt.c, so that IMA can start measuring the status of
     various dm-crypt targets (represented by crypt_target struct - also
     defined in dm-crypt.c).
     The mapping table[3] has information of devices being encrypted
     (start sector, size, target name, cypher, key, device path, and
     other optional parameters.)
     e.g.
     0 417792 crypt serpent-cbc-essiv:sha256
     a7f67ad520bd83b9725df6ebd76c3eee 0 /dev/sdb 0 1 allow_discards

     We can pass various attributes of mapping table to IMA through a key
     value pair of various dmcrypt constructs.

     Proposed Function Signature of the IMA hook:
     void ima_dmcrypt_status(void *dmcrypt_status, int len);

B. Measuring selinux constructs:
     We propose to add an IMA hook in enforcing_set() present under
     security/selinux/include/security.h.
     enforcing_set() sets the selinux state to enforcing/permissive etc.
     and is called from key places like selinux_init(),
     sel_write_enforce() etc.
     The hook will measure various attributes related to selinux status.
     Majority of the attributes are present in the struct selinux_state
     present in security/selinux/include/security.h
     e.g.
     $sestatus
            SELinux status:              enabled
            SELinuxfs mount:             /sys/fs/selinux
            SELinux root directory:      /etc/selinux
            Loaded policy name:          default
            Current mode:                permissive
            Mode from config file:       permissive
            Policy MLS status:           enabled
            Policy deny_unknown status:  allowed
            Memory protection checking:  requested (insecure)
            Max kernel policy version:   32

     The above attributes will be serialized into a set of key=value
     pairs when passed to IMA for measurement.

     Proposed Function Signature of the IMA hook:
     void ima_selinux_status(void *selinux_status, int len);

Please provide comments\feedback on the proposal.

Thanks,
Tushar

[1] https://sourceforge.net/p/linux-ima/wiki/Home/
[2] https://selinuxproject.org/page/FAQ
[3] https://gitlab.com/cryptsetup/cryptsetup/wikis/DMCrypt
