From: Nikolay Borisov <kernel@kyup.com>
Subject: Re: [PATCH v3 0/7] User namespace mount updates
Date: Wed, 18 Nov 2015 17:36:49 +0200
Message-ID: <564C9B11.3020702@kyup.com>
References: <1447778351-118699-1-git-send-email-seth.forshee@canonical.com>
 <20151117170556.GV22011@ZenIV.linux.org.uk>
 <20151117172551.GA108807@ubuntu-hedt>
 <20151117175506.GW22011@ZenIV.linux.org.uk> <564B79B1.3040207@gmail.com>
 <20151117191606.GC108807@ubuntu-hedt> <564B941A.2070601@gmail.com>
 <20151117213255.GE108807@ubuntu-hedt> <564C6DD4.6090308@gmail.com>
 <20151118142238.GB134139@ubuntu-hedt>
 <20151118145818.GC22011@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151118145818.GC22011@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@ZenIV.linux.org.uk>, Seth Forshee <seth.forshee@canonical.com>
Cc: Austin S Hemmelgarn <ahferroin7@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>, linux-bcache@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov, Serge Hallyn <serge.hallyn@canonical.com>, Andy Lutomirski <luto@amacapital.net>, linux-kernel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
List-Id: dm-devel.ids



On 11/18/2015 04:58 PM, Al Viro wrote:
> On Wed, Nov 18, 2015 at 08:22:38AM -0600, Seth Forshee wrote:
> 
>> But it still requires the admin set it up that way, no? And aren't
>> privileges required to set up those devices in the first place?
>>
>> I'm not saying that it wouldn't be a good idea to lock down the backing
>> stores for those types of devices too, just that it isn't something that
>> a regular user could exploit without an admin doing something to
>> facilitate it.
> 
> Sigh...  If it boils down to "all admins within all containers must be
> trusted not to try and break out" (along with "roothole in any container
> escalates to kernel-mode code execution on host"), then what the fuck
> is the *point* of bothering with containers, userns, etc. in the first
> place?  If your model is basically "you want isolation, just use kvm",
> fine, but where's the place for userns in all that?
> 
> And if you are talking about the _host_ admin, then WTF not have him just
> mount what's needed as part of setup and to hell with mounting those
> inside the container?
> 
> Look at that from the hosting company POV - they are offering a bunch of
> virtual machines on one physical system.  And you want the admins on those
> virtual machines independent from the host admin.  Fine, but then you
> really need to keep them unable to screw each other or gain kernel-mode
> execution on the host.

Actually from the POV of a hosting company there's also the use case of
wanting to use container as substitutes for virtual machines (of course
we are a long way from that). But being able to do what those patches
enable (i.e. what Seth has pointed to with mount -o loop) is beneficial
and desirable.

> 
> Again, what's the point of all that?  I assumed the model where containers
> do, you know, contain what's in them, regardless of trust.  You guys seem
> to assume something different and I really wonder what it _is_...
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
