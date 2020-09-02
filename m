From: Mike Snitzer <snitzer@redhat.com>
Subject: flood of "dm-X: error: dax access failed" due to 5.9
 commit 231609785cbfb
Date: Wed, 2 Sep 2020 12:04:32 -0400
Message-ID: <20200902160432.GA5513@redhat.com>
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
Content-Disposition: inline
To: Coly Li <colyli@suse.de>, Jan Kara <jack@suse.com>, Ira Weiny <ira.weiny@intel.com>, Pankaj Gupta <pankaj.gupta.linux@gmail.com>, Vishal Verma <vishal.l.verma@intel.com>
Cc: dm-devel@redhat.com, linux-nvdimm@lists.01.org
List-Id: dm-devel.ids

5.9 commit 231609785cbfb ("dax: print error message by pr_info() in
__generic_fsdax_supported()") switched from pr_debug() to pr_info().

The justification in the commit header is really inadequate.  If there
is a problem that you need to drill in on, repeat the testing after
enabling the dynamic debugging.

Otherwise, now all DM devices that aren't layered on DAX capable devices
spew really confusing noise to users when they simply activate their
non-DAX DM devices:

[66567.129798] dm-6: error: dax access failed (-5)
[66567.134400] dm-6: error: dax access failed (-5)
[66567.139152] dm-6: error: dax access failed (-5)
[66567.314546] dm-2: error: dax access failed (-95)
[66567.319380] dm-2: error: dax access failed (-95)
[66567.324254] dm-2: error: dax access failed (-95)
[66567.479025] dm-2: error: dax access failed (-95)
[66567.483713] dm-2: error: dax access failed (-95)
[66567.488722] dm-2: error: dax access failed (-95)
[66567.494061] dm-2: error: dax access failed (-95)
[66567.498823] dm-2: error: dax access failed (-95)
[66567.503693] dm-2: error: dax access failed (-95)

commit 231609785cbfb must be reverted.

Please advise, thanks.
Mike
