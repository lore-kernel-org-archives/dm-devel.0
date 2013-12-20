From: Joe Thornber <thornber@redhat.com>
Subject: Re: Is it possible to live resize a  dmcache volume?
Date: Fri, 20 Dec 2013 16:46:50 +0000
Message-ID: <20131220164649.GC15982@debian>
References: <1387507035.5506.1.camel@daniel.ewheeler.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1387507035.5506.1.camel@daniel.ewheeler.net>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Thu, Dec 19, 2013 at 06:37:15PM -0800, Daniel Wheeler wrote:
> Does dmcache support live resize?

Yes, see these tests:

https://github.com/jthornber/device-mapper-test-suite/blob/master/lib/dmtest/tests/cache/resize_tests.rb
