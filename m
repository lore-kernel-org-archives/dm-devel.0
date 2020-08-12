From: Deven Bowers <deven.desai@linux.microsoft.com>
Subject: Re: [dm-devel] [RFC PATCH v5 00/11] Integrity Policy Enforcement LSM
 (IPE)
Date: Wed, 12 Aug 2020 10:07:04 -0700
Message-ID: <5edd58e3-7f12-10af-ef1c-4c1b32cf99e4@linux.microsoft.com>
References: <20200728213614.586312-1-deven.desai@linux.microsoft.com>
 <20200802115545.GA1162@bug> <20200802140300.GA2975990@sasha-vm>
 <20200802143143.GB20261@amd> <1596386606.4087.20.camel@HansenPartnership.com>
 <fb35a1f7-7633-a678-3f0f-17cf83032d2b@linux.microsoft.com>
 <1596639689.3457.17.camel@HansenPartnership.com>
 <alpine.LRH.2.21.2008050934060.28225@namei.org>
 <b08ae82102f35936427bf138085484f75532cff1.camel@linux.ibm.com>
 <329E8DBA-049E-4959-AFD4-9D118DEB176E@gmail.com>
 <alpine.LRH.2.21.2008120643370.10591@namei.org>
 <70603A4E-A548-4ECB-97D4-D3102CE77701@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <70603A4E-A548-4ECB-97D4-D3102CE77701@gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Chuck Lever <chucklever@gmail.com>, James Morris <jmorris@namei.org>
Cc: Mimi Zohar <zohar@linux.ibm.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Pavel Machek <pavel@ucw.cz>, Sasha Levin <sashal@kernel.org>, snitzer@redhat.com, dm-devel@redhat.com, tyhicks@linux.microsoft.com, agk@redhat.com, Paul Moore <paul@paul-moore.com>, Jonathan Corbet <corbet@lwn.net>, nramas@linux.microsoft.com, serge@hallyn.com, pasha.tatashin@soleen.com, Jann Horn <jannh@google.com>, linux-block@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, Jens Axboe <axboe@kernel.dk>, mdsakib@microsoft.com, open list <linux-kernel@vger.kernel.org>, eparis@redhat.com, linux-security-module@vger.kernel.org, linux-audit@redhat.com, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-integrity@vger.kernel.org, jaskarankhurana@linux.microsoft.com
List-Id: dm-devel.ids



On 8/12/2020 7:18 AM, Chuck Lever wrote:
> 
> 
>> On Aug 11, 2020, at 5:03 PM, James Morris <jmorris@namei.org> wrote:
>>
>> On Sat, 8 Aug 2020, Chuck Lever wrote:
>>
>>> My interest is in code integrity enforcement for executables stored
>>> in NFS files.
>>>
>>> My struggle with IPE is that due to its dependence on dm-verity, it
>>> does not seem to able to protect content that is stored separately
>>> from its execution environment and accessed via a file access
>>> protocol (FUSE, SMB, NFS, etc).
>>
>> It's not dependent on DM-Verity, that's just one possible integrity
>> verification mechanism, and one of two supported in this initial
>> version. The other is 'boot_verified' for a verified or otherwise trusted
>> rootfs. Future versions will support FS-Verity, at least.
>>
>> IPE was designed to be extensible in this way, with a strong separation of
>> mechanism and policy.
> 
> I got that, but it looked to me like the whole system relied on having
> access to the block device under the filesystem. That's not possible
> for a remote filesystem like Ceph or NFS.

Block device structure no, (though that's what the currently used, to be
fair). It really has a hard dependency on the file structure,
specifically the ability to determine whether that file structure can be 
used to navigate back to the integrity claim provided by the mechanism.

In the current world of IPE, the integrity claim is the root-hash or 
root-hash-signature on the block device, provided by dm-verity's 
setsecurity hooks (also introduced in this series).

> 
> I'm happy to take a closer look if someone can point me the right way.
> 

Sure, if you look at the 2nd patch, you want to look at the file 
"security/ipe/ipe-property.h", it defines what methods are required to
be implemented by a mechanism to work with IPE. It passes the engine
context which is defined as:

  struct ipe_engine_ctx {
  	enum ipe_op op;
  	enum ipe_hook hook;
  	const struct file *file;
  	const char *audit_pathname;
	const struct ipe_bdev_blob *sec_bdev;
  };

Now, if the security blob existed for the block_device, it would be
in sec_bdev, but that may be NULL, as well to be fair.

If you want a more worked example of how integration works, patches 8
and 10 introduce the dm-verity properties mentioned in this patch.
