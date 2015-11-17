From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH v3 0/7] User namespace mount updates
Date: Tue, 17 Nov 2015 17:55:06 +0000
Message-ID: <20151117175506.GW22011@ZenIV.linux.org.uk>
References: <1447778351-118699-1-git-send-email-seth.forshee@canonical.com>
 <20151117170556.GV22011@ZenIV.linux.org.uk>
 <20151117172551.GA108807@ubuntu-hedt>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20151117172551.GA108807@ubuntu-hedt>
Sender: linux-raid-owner@vger.kernel.org
To: Seth Forshee <seth.forshee@canonical.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-bcache@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov, Serge Hallyn <serge.hallyn@canonical.com>, Andy Lutomirski <luto@amacapital.net>, linux-kernel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
List-Id: dm-devel.ids

On Tue, Nov 17, 2015 at 11:25:51AM -0600, Seth Forshee wrote:

> Shortly after that I plan to follow with support for ext4. I've been
> fuzzing ext4 for a while now and it has held up well, and I'm currently
> working on hand-crafted attacks. Ted has commented privately (to others,
> not to me personally) that he will fix bugs for such attacks, though I
> haven't seen any public comments to that effect.

_Static_ attacks, or change-image-under-mounted-fs attacks?
