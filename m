From: Ben England <bengland@redhat.com>
Subject: getting feedback on dm-cache statistics tool
Date: Thu, 26 May 2016 12:00:00 -0400 (EDT)
Message-ID: <1521667453.66151545.1464278400970.JavaMail.zimbra@redhat.com>
References: <2055307845.66145553.1464277400592.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <2055307845.66145553.1464277400592.JavaMail.zimbra@redhat.com>
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

I have a git repo containing a tool I wrote to look at dm-cache statistics, not the raw counters in "dmsetup status" but derived values that are more directly useful to system administrators and developers that want to see whether dm-cache is doing what they want it to.

https://github.com/bengland2/dmcache-stat

Any feedback on this?  Anything missing?  I don't mind adding or taking pull requests.  If some other tool can provide the same functionality within RHEL then I'm happy to use that.   

-ben
