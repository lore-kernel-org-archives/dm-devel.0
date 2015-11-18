From: James Morris <jmorris@namei.org>
Subject: Re: [PATCH v3 6/7] userns: Replace in_userns with
 current_in_userns
Date: Wed, 18 Nov 2015 11:03:58 +1100 (AEDT)
Message-ID: <alpine.LRH.2.20.1511181103400.1460@namei.org>
References: <1447778351-118699-1-git-send-email-seth.forshee@canonical.com> <1447778351-118699-7-git-send-email-seth.forshee@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1447778351-118699-7-git-send-email-seth.forshee@canonical.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Seth Forshee <seth.forshee@canonical.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Serge Hallyn <serge.hallyn@canonical.com>, James Morris <james.l.morris@oracle.com>, "Serge E. Hallyn" <serge@hallyn.com>, Andy Lutomirski <luto@amacapital.net>, linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov
List-Id: dm-devel.ids

On Tue, 17 Nov 2015, Seth Forshee wrote:

> All current callers of in_userns pass current_user_ns as the
> first argument. Simplify by replacing in_userns with
> current_in_userns which checks whether current_user_ns is in the
> namespace supplied as an argument.
> 
> Signed-off-by: Seth Forshee <seth.forshee@canonical.com>

Nice cleanup.


Acked-by: James Morris <james.l.morris@oracle.com>

-- 
James Morris
<jmorris@namei.org>

