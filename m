From: James Morris <jmorris@namei.org>
Subject: Re: [PATCH v3 7/7] Smack: Handle labels consistently in untrusted
 mounts
Date: Wed, 18 Nov 2015 11:12:51 +1100 (AEDT)
Message-ID: <alpine.LRH.2.20.1511181112090.1460@namei.org>
References: <1447778351-118699-1-git-send-email-seth.forshee@canonical.com> <1447778351-118699-8-git-send-email-seth.forshee@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1447778351-118699-8-git-send-email-seth.forshee@canonical.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Seth Forshee <seth.forshee@canonical.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Casey Schaufler <casey@schaufler-ca.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Serge Hallyn <serge.hallyn@canonical.com>, Andy Lutomirski <luto@amacapital.net>, linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov, James Morris <james.l.morris@oracle.com>, "Serge E. Hallyn" <serge@hallyn.com>
List-Id: dm-devel.ids

On Tue, 17 Nov 2015, Seth Forshee wrote:

> +	sbsp = inode->i_sb->s_security;
> +	if ((sbsp->smk_flags & SMK_SB_UNTRUSTED) &&

Where is SMK_SB_UNTRUSTED defined?

I can't see it in this patch series, mainline or security next.


-- 
James Morris
<jmorris@namei.org>

