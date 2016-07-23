From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: multipath-tools releases in website / untagged release
Date: Sat, 23 Jul 2016 10:55:38 +0200
Message-ID: <75937b18-6a39-b126-84ad-07919343a617@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi Christophe,

multipath-tools website still says that latest release is: 0.5.0
And it's confusing and wrong.

Could you please replace it with instructions from README?. Something like:

"tarballs are not generated anymore, to get a specific release do:
git clone http://git.opensvc.com/multipath-tools/.git
cd multipath-tools
git tag
git archive --format=tar.gz --prefix=multipath-tools-X.Y.Z/ X.Y.Z > ../multipath-tools-X.Y.Z.tar.gz

Alternatively it may be obtained from gitweb, go to:
http://git.opensvc.com/?p=multipath-tools/.git;a=tags
select a release-tag and then click on "snapshot"."


BTW, *0.6.2 was NOT tagged in git*


Thank you.
