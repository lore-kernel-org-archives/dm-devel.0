From: James Morris <jmorris@namei.org>
Subject: Re: [PATCH v3 5/7] selinux: Add support for unprivileged mounts from
 user namespaces
Date: Wed, 18 Nov 2015 11:02:25 +1100 (AEDT)
Message-ID: <alpine.LRH.2.20.1511181101290.1460@namei.org>
References: <1447778351-118699-1-git-send-email-seth.forshee@canonical.com> <1447778351-118699-6-git-send-email-seth.forshee@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-bcache-owner@vger.kernel.org>
In-Reply-To: <1447778351-118699-6-git-send-email-seth.forshee@canonical.com>
Sender: linux-bcache-owner@vger.kernel.org
To: Seth Forshee <seth.forshee@canonical.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Paul Moore <paul@paul-moore.com>, Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Serge Hallyn <serge.hallyn@canonical.com>, Andy Lutomirski <luto@amacapital.net>, linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov, James Morris <james.l.morris@oracle.com>, "Serge E. Hallyn" <serge@hallyn.com>
List-Id: dm-devel.ids

On Tue, 17 Nov 2015, Seth Forshee wrote:

> Security labels from unprivileged mounts in user namespaces must
> be ignored. Force superblocks from user namespaces whose labeling
> behavior is to use xattrs to use mountpoint labeling instead.
> For the mountpoint label, default to converting the current task
> context into a form suitable for file objects, but also allow the
> policy writer to specify a different label through policy
> transition rules.
> 
> Pieced together from code snippets provided by Stephen Smalley.
> 
> Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
> Acked-by: Stephen Smalley <sds@tycho.nsa.gov>


Acked-by: James Morris <james.l.morris@oracle.com>

-- 
James Morris
<jmorris@namei.org>
