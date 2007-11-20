From: "Scott Moseman" <scmoseman@gmail.com>
Subject: failover vs multibus
Date: Tue, 20 Nov 2007 08:19:06 -0600
Message-ID: <342d47870711200619u13d3a960see0d0cf5e65326bf@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

Re: default_path_grouping_policy in multipath.conf

failover = 1 path per priority group
multibus = all valid paths in 1 priority group

Does this mean that if I'm using failover I'm not going to get
multiple path throughput?  And, on the flip side, if I'm sending data
through multiple paths I'm not going to get failover support?
Obviously I want to have both (or all) channels sending traffic, but
still being able to failover in the event I lose a path.  Maybe this
means my multipath.conf is going to get more complex than the standard
configuration sample?

Thanks,
Scott
