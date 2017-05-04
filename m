From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH v6 0/3] dm: boot a mapped device without an
        initramfs
Date: Thu, 4 May 2017 14:20:07 +0100
Message-ID: <20170504132007.GG4943@agk-dp.fab.redhat.com>
References: <20170418164240.18079-1-enric.balletbo@collabora.com> <CAGXu5jLD+0POz1sopyZNNqDAiq2MZ5ZYdjs43jX5OnWxkZt1Lg@mail.gmail.com> <CAFqH_51YLoYrNcw+Fb99LbSY63wVWg+MW7nBYQqWjV6qfOAmNQ@mail.gmail.com> <20170504121452.GF4943@agk-dp.fab.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170504121452.GF4943@agk-dp.fab.redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Enric Balletbo Serra <eballetbo@gmail.com>
Cc: Kees Cook <keescook@chromium.org>, Will Drewry <wad@chromium.org>, Guenter Roeck <groeck@google.com>, Mike Snitzer <snitzer@redhat.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, David Zeuthen <zeuthen@google.com>, LKML <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org, dm-devel@redhat.com, Enric Balletbo i Serra <enric.balletbo@collabora.com>, Shaohua Li <shli@kernel.org>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Some more thoughts with your example, dmsetup might look like:

# dmsetup create --bootformat "lroot:uuid,rw,0 2097152 linear 8:2 0, \
2097152 2097152 linear 8:3 0, 4194304 2097152 linear 8:4 0"

- also supporting creating multiple devices if the semi-colon is used

- colon to separate name from uuid, like we already do major:minor 
- colon to separate other flags from rw if we need them in future

- splitting first on a unescaped semi-colons, then on the first two
unescaped commas, and then on unescaped commas and then unescaped spaces
within the table

- backslash escapes the following character so it is never a treated
as a separator
  - lroot\:uuid\;\\\ \"\, would be a device with no uuid and the name
    lroot:uuid;\ ",  (on a non-udev system without name mangling)

# dmsetup ls --bootformat lroot
dm="lroot:uuid,rw,0 2097152 linear 8:2 0, 2097152 2097152 \
linear 8:3 0, 4194304 2097152 linear 8:4 0"

# dmsetup ls --bootformat
(all devices on one output line)

While the code also supports devices in the /dev/sda2 format for 
convenience, please use the preferred 8:2 format in any implementation
and documented examples (to avoid the unnecessary dependency on /dev and
its dependencies).

Or with some alternative name for the option
--boot[format|param]
--short[format]
--kernelparam
--condensed
other suggestions?

dmsetup create --condensed
dmsetup ls --condensed

Alasdair

