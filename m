From: James Morris <jmorris@namei.org>
Subject: Re: [PATCH v3 4/7] fs: Treat foreign mounts as nosuid
Date: Wed, 18 Nov 2015 11:00:53 +1100 (AEDT)
Message-ID: <alpine.LRH.2.20.1511181100380.1460@namei.org>
References: <1447778351-118699-1-git-send-email-seth.forshee@canonical.com> <1447778351-118699-5-git-send-email-seth.forshee@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1447778351-118699-5-git-send-email-seth.forshee@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Seth Forshee <seth.forshee@canonical.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Serge Hallyn <serge.hallyn@canonical.com>, James Morris <james.l.morris@oracle.com>, "Serge E. Hallyn" <serge@hallyn.com>, Paul Moore <paul@paul-moore.com>, Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>, Andy Lutomirski <luto@amacapital.net>, linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov
List-Id: dm-devel.ids

On Tue, 17 Nov 2015, Seth Forshee wrote:

> From: Andy Lutomirski <luto@amacapital.net>
> 
> If a process gets access to a mount from a different user
> namespace, that process should not be able to take advantage of
> setuid files or selinux entrypoints from that filesystem.  Prevent
> this by treating mounts from other mount namespaces and those not
> owned by current_user_ns() or an ancestor as nosuid.
> 
> This will make it safer to allow more complex filesystems to be
> mounted in non-root user namespaces.
> 
> This does not remove the need for MNT_LOCK_NOSUID.  The setuid,
> setgid, and file capability bits can no longer be abused if code in
> a user namespace were to clear nosuid on an untrusted filesystem,
> but this patch, by itself, is insufficient to protect the system
> from abuse of files that, when execed, would increase MAC privilege.
> 
> As a more concrete explanation, any task that can manipulate a
> vfsmount associated with a given user namespace already has
> capabilities in that namespace and all of its descendents.  If they
> can cause a malicious setuid, setgid, or file-caps executable to
> appear in that mount, then that executable will only allow them to
> elevate privileges in exactly the set of namespaces in which they
> are already privileges.
> 
> On the other hand, if they can cause a malicious executable to
> appear with a dangerous MAC label, running it could change the
> caller's security context in a way that should not have been
> possible, even inside the namespace in which the task is confined.
> 
> As a hardening measure, this would have made CVE-2014-5207 much
> more difficult to exploit.
> 
> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
> Signed-off-by: Seth Forshee <seth.forshee@canonical.com>


Acked-by: James Morris <james.l.morris@oracle.com>

-- 
James Morris
<jmorris@namei.org>
