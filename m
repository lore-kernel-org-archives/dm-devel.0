From: Roger Heflin <rogerheflin@gmail.com>
Subject: question about multipathd patch thought.
Date: Fri, 14 Feb 2020 08:47:33 -0600
Message-ID: <CAAMCDefQhNmMN+bys+ASU8sw4zu-FkbC7o=emzYhpzOKy7N0jg@mail.gmail.com>
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Because of some tools we use to "move" luns from one array to another,
we have ended up with duplicate lunids (human errors around the
designed process) on 2 separate arrays presented to the exact same
hosts.  This has caused multipath to assemble all 4 paths into the
same device, 2 of which don't have the same data.  The environment I
work in has 1000's of physical hosts, and 100's arrays.

If I were to create and submit a patch to validate (if say we set
verify_new_path_matches to yes in the config file, default is no) that
the new paths size, vendor, and model match, if they don't match then
print to syslog, and don't add it to the path. It is understood that
when we use this option when we are using the tool that causes the
above problem we would need to disable that option, and once that
process is finished then re-enable the option.   If such a patch was
created would the patch be accepted to the multipath upstream?

Roger Heflin
