From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: multipath-tools git repository is unavailable
Date: Tue, 12 May 2015 10:41:55 -0500
Message-ID: <20150512154155.GF3001@octiron.msp.redhat.com>
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
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

I've just recently tried a "git pull" on my multipath repository, and I
got:

$ git pull
fatal: repository 'http://git.opensvc.com/multipath-tools/.git/' not found

I appear to be completely unable to access the repository through either
http or git. Everything looks fine through Gitweb, however.

Just to check, I tried to clone some of the other repositories at
git.opensvc.com, and I can't access any of them.

Any idea what's up?

-Ben
