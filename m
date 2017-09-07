From: Josef Bacik <josef@toxicpanda.com>
Subject: Re: [dm-devel] [RFC] Multi-device dm-log-writes
Date: Thu, 7 Sep 2017 09:54:26 -0400
Message-ID: <20170907135424.yko6ognrjy7hkfy7@destiny>
References: <20170901183110.qjyxjrrksnub7y4a@destiny>
 <b32fb3c9-cb93-f3ee-74b7-37884e24b580@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <b32fb3c9-cb93-f3ee-74b7-37884e24b580@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Heinz Mauelshagen <heinzm@redhat.com>
Cc: Josef Bacik <josef@toxicpanda.com>, snitzer@redhat.com, amir73il@gmail.com, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, kernel-team@fb.com, clm@fb.com, osandov@fb.com, rwareing@fb.com
List-Id: dm-devel.ids

On Mon, Sep 04, 2017 at 04:42:53PM +0200, Heinz Mauelshagen wrote:
> Josef,
> 
> using the current log-writes target, would a device tree with a single large
> logged device sliced up into N linear mappings used by btrfs/md/... work to?
> Or would that miss any semantics as of your design?
> 

Huh that's a good question.  So it would work, but we would lose out on the
ability to replay different devices in different orders because we would
essentially be making each individual device a certain area on the log device.
We could test things like random replay and such, but things like making sure
flush'es are handled properly per device would get lost.  Thanks,

Josef
