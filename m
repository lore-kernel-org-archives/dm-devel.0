From: Michae Lyulko <michaell@voltaire.com>
Subject: Failover between two paths to one LU doesn't work on
	linux-iscsi
Date: Tue, 10 Oct 2006 19:17:58 +0200
Message-ID: <452BD5C6.2080808@voltaire.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

Hello,
I use linux-iscsi initiator and device-mapper to access a LU that has 
two paths to it.
When one of the paths fails no fail-over occurs (waited for 15 minutes).
The device appears in /dev/mapper/
I know that on open-iscsi initiator the fail-over does happen.

1. Are there any known problems that can cause fail-over not to happen 
in linux-iscsi?
2. Is there any way to get debug information in order to understand more
in-depth what's going on?
3. How can I know what the timeouts are and how to change them?
4. If you need more specific information, please write what can help.

Michael
