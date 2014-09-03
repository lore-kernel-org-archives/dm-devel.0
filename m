From: Joe Thornber <thornber@redhat.com>
Subject: [ANNOUNCE] thin-provisioning-tools v0.4.0
Date: Wed, 3 Sep 2014 13:32:33 +0100
Message-ID: <20140903123232.GA25313@debian>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

There's a new release of the increasingly inaccurately named
thin-provisioning-tools:

https://github.com/jthornber/thin-provisioning-tools/releases/tag/v0.4.0

This contains tools for manipulating the dm metadata for dm-thin,
dm-cache and dm-era.

There is also an updated thinp_xml Ruby gem which can generate, parse
and emit the XML format of the above three metadata types.

https://rubygems.org/gems/thinp_xml




Changes
=======

- All tools switch to using libaio.  This gives a large performance
  boost, especially to the write focused tools like thin_restore.

- Added a progress monitor to thin_restore, cache_restore and era_restore

- Added a --quiet/-q option to *_restore to turn off the progress bar

- Removed variable hint size support from cache tools.  The kernel
  still only supports a fixed 32bit width.  This will have a side
  effect of reducing the executable sizes due to less template
  instatiation.

- Tools rolled into a single executable to save space.

- Fixed some bugs when walking bitsets (possibly effecting cache_dump
  and cache_check).
