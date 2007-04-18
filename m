From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: [PATCH] libdevmapper: (3/6) Move lib/regex from LVM2
Date: Wed, 18 Apr 2007 12:47:34 -0400
Message-ID: <46264BA6.3050104@ce.jp.nec.com>
References: <46264A57.1020800@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------080309060207020107040404"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <46264A57.1020800@ce.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--------------080309060207020107040404
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit

Hi,

This patch just moves lib/regex from LVM2 as a preparation for
the filtering feature of dm_report.

Now, the following functions are exported:
  - dm_regex_create()
  - dm_regex_match()

Corresponding patch to LVM2 will be posted to lvm-devel.

Thanks,
-- 
Jun'ichi Nomura, NEC Corporation of America

--------------080309060207020107040404
Content-Type: text/x-patch;
 name="libdm-regex.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="libdm-regex.patch"

Moved lib/regex from LVM2

Exported functions and a structure are renamed:
  - matcher_create() -> dm_regex_create()
  - matcher_run()    -> dm_regex_match()
  - struct matcher   -> struct dm_regex

---
 lib/.exported_symbols |    2 
 lib/Makefile.in       |    3 
 lib/libdevmapper.h    |    7 
 lib/regex/matcher.c   |  366 ++++++++++++++++++++++++++++++++++++++++++++++++++
 lib/regex/parse_rx.c  |  360 +++++++++++++++++++++++++++++++++++++++++++++++++
 lib/regex/parse_rx.h  |   52 +++++++
 lib/regex/ttree.c     |  117 +++++++++++++++
 lib/regex/ttree.h     |   26 +++
 8 files changed, 933 insertions(+)

Index: device-mapper.work/lib/.exported_symbols
===================================================================
--- device-mapper.work.orig/lib/.exported_symbols
+++ device-mapper.work/lib/.exported_symbols
@@ -127,3 +127,5 @@ dm_report_field_int32
 dm_report_field_uint32
 dm_report_field_uint64
 dm_report_field_set_value
+dm_regex_create
+dm_regex_match
Index: device-mapper.work/lib/libdevmapper.h
===================================================================
--- device-mapper.work.orig/lib/libdevmapper.h
+++ device-mapper.work/lib/libdevmapper.h
@@ -711,4 +711,11 @@ int dm_report_field_uint64(struct dm_rep
 void dm_report_field_set_value(struct dm_report_field *field, const void *value,
 			       const void *sortvalue);
 
+/*
+ * dm_regex
+ */
+struct dm_regex;
+struct dm_regex *dm_regex_create(struct dm_pool *mem, const char **patterns,
+				 unsigned num);
+int dm_regex_match(struct dm_regex *regex, const char *s);
 #endif				/* LIB_DEVICE_MAPPER_H */
Index: device-mapper.work/lib/regex/matcher.c
===================================================================
--- /dev/null
+++ device-mapper.work/lib/regex/matcher.c
@@ -0,0 +1,366 @@
+/*
+ * Copyright (C) 2001-2004 Sistina Software, Inc. All rights reserved.
+ * Copyright (C) 2004 Red Hat, Inc. All rights reserved.
+ *
+ * This file is part of the device-mapper userspace tools.
+ *
+ * This copyrighted material is made available to anyone wishing to use,
+ * modify, copy, or redistribute it subject to the terms and conditions
+ * of the GNU General Public License v.2.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software Foundation,
+ * Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#include "lib.h"
+#include "parse_rx.h"
+#include "ttree.h"
+
+#define assert(x) do { if (!(x)) log_error("assertion failed"); } while(0)
+
+struct dfa_state {
+	int final;
+	struct dfa_state *lookup[256];
+};
+
+struct state_queue {
+	struct dfa_state *s;
+	dm_bitset_t bits;
+	struct state_queue *next;
+};
+
+struct dm_regex {		/* Instance variables for the lexer */
+	struct dfa_state *start;
+	unsigned num_nodes;
+	int nodes_entered;
+	struct rx_node **nodes;
+	struct dm_pool *scratch, *mem;
+};
+
+#define TARGET_TRANS '\0'
+
+static int _count_nodes(struct rx_node *rx)
+{
+	int r = 1;
+
+	if (rx->left)
+		r += _count_nodes(rx->left);
+
+	if (rx->right)
+		r += _count_nodes(rx->right);
+
+	return r;
+}
+
+static void _fill_table(struct dm_regex *m, struct rx_node *rx)
+{
+	assert((rx->type != OR) || (rx->left && rx->right));
+
+	if (rx->left)
+		_fill_table(m, rx->left);
+
+	if (rx->right)
+		_fill_table(m, rx->right);
+
+	m->nodes[m->nodes_entered++] = rx;
+}
+
+static void _create_bitsets(struct dm_regex *m)
+{
+	int i;
+
+	for (i = 0; i < m->num_nodes; i++) {
+		struct rx_node *n = m->nodes[i];
+		n->firstpos = dm_bitset_create(m->scratch, m->num_nodes);
+		n->lastpos = dm_bitset_create(m->scratch, m->num_nodes);
+		n->followpos = dm_bitset_create(m->scratch, m->num_nodes);
+	}
+}
+
+static void _calc_functions(struct dm_regex *m)
+{
+	int i, j, final = 1;
+	struct rx_node *rx, *c1, *c2;
+
+	for (i = 0; i < m->num_nodes; i++) {
+		rx = m->nodes[i];
+		c1 = rx->left;
+		c2 = rx->right;
+
+		if (dm_bit(rx->charset, TARGET_TRANS))
+			rx->final = final++;
+
+		switch (rx->type) {
+		case CAT:
+			if (c1->nullable)
+				dm_bit_union(rx->firstpos,
+					  c1->firstpos, c2->firstpos);
+			else
+				dm_bit_copy(rx->firstpos, c1->firstpos);
+
+			if (c2->nullable)
+				dm_bit_union(rx->lastpos,
+					  c1->lastpos, c2->lastpos);
+			else
+				dm_bit_copy(rx->lastpos, c2->lastpos);
+
+			rx->nullable = c1->nullable && c2->nullable;
+			break;
+
+		case PLUS:
+			dm_bit_copy(rx->firstpos, c1->firstpos);
+			dm_bit_copy(rx->lastpos, c1->lastpos);
+			rx->nullable = c1->nullable;
+			break;
+
+		case OR:
+			dm_bit_union(rx->firstpos, c1->firstpos, c2->firstpos);
+			dm_bit_union(rx->lastpos, c1->lastpos, c2->lastpos);
+			rx->nullable = c1->nullable || c2->nullable;
+			break;
+
+		case QUEST:
+		case STAR:
+			dm_bit_copy(rx->firstpos, c1->firstpos);
+			dm_bit_copy(rx->lastpos, c1->lastpos);
+			rx->nullable = 1;
+			break;
+
+		case CHARSET:
+			dm_bit_set(rx->firstpos, i);
+			dm_bit_set(rx->lastpos, i);
+			rx->nullable = 0;
+			break;
+
+		default:
+			log_error("Internal error: Unknown calc node type");
+		}
+
+		/*
+		 * followpos has it's own switch
+		 * because PLUS and STAR do the
+		 * same thing.
+		 */
+		switch (rx->type) {
+		case CAT:
+			for (j = 0; j < m->num_nodes; j++) {
+				if (dm_bit(c1->lastpos, j)) {
+					struct rx_node *n = m->nodes[j];
+					dm_bit_union(n->followpos,
+						  n->followpos, c2->firstpos);
+				}
+			}
+			break;
+
+		case PLUS:
+		case STAR:
+			for (j = 0; j < m->num_nodes; j++) {
+				if (dm_bit(rx->lastpos, j)) {
+					struct rx_node *n = m->nodes[j];
+					dm_bit_union(n->followpos,
+						  n->followpos, rx->firstpos);
+				}
+			}
+			break;
+		}
+	}
+}
+
+static struct dfa_state *_create_dfa_state(struct dm_pool *mem)
+{
+	return dm_pool_zalloc(mem, sizeof(struct dfa_state));
+}
+
+static struct state_queue *_create_state_queue(struct dm_pool *mem,
+					       struct dfa_state *dfa,
+					       dm_bitset_t bits)
+{
+	struct state_queue *r = dm_pool_alloc(mem, sizeof(*r));
+
+	if (!r) {
+		stack;
+		return NULL;
+	}
+
+	r->s = dfa;
+	r->bits = dm_bitset_create(mem, bits[0]);	/* first element is the size */
+	dm_bit_copy(r->bits, bits);
+	r->next = 0;
+	return r;
+}
+
+static int _calc_states(struct dm_regex *m, struct rx_node *rx)
+{
+	unsigned iwidth = (m->num_nodes / DM_BITS_PER_INT) + 1;
+	struct ttree *tt = ttree_create(m->scratch, iwidth);
+	struct state_queue *h, *t, *tmp;
+	struct dfa_state *dfa, *ldfa;
+	int i, a, set_bits = 0, count = 0;
+	dm_bitset_t bs, dfa_bits;
+
+	if (!tt)
+		return_0;
+
+	if (!(bs = dm_bitset_create(m->scratch, m->num_nodes)))
+		return_0;
+
+	/* create first state */
+	dfa = _create_dfa_state(m->mem);
+	m->start = dfa;
+	ttree_insert(tt, rx->firstpos + 1, dfa);
+
+	/* prime the queue */
+	h = t = _create_state_queue(m->scratch, dfa, rx->firstpos);
+	while (h) {
+		/* pop state off front of the queue */
+		dfa = h->s;
+		dfa_bits = h->bits;
+		h = h->next;
+
+		/* iterate through all the inputs for this state */
+		dm_bit_clear_all(bs);
+		for (a = 0; a < 256; a++) {
+			/* iterate through all the states in firstpos */
+			for (i = dm_bit_get_first(dfa_bits);
+			     i >= 0; i = dm_bit_get_next(dfa_bits, i)) {
+				if (dm_bit(m->nodes[i]->charset, a)) {
+					if (a == TARGET_TRANS)
+						dfa->final = m->nodes[i]->final;
+
+					dm_bit_union(bs, bs,
+						  m->nodes[i]->followpos);
+					set_bits = 1;
+				}
+			}
+
+			if (set_bits) {
+				ldfa = ttree_lookup(tt, bs + 1);
+				if (!ldfa) {
+					/* push */
+					ldfa = _create_dfa_state(m->mem);
+					ttree_insert(tt, bs + 1, ldfa);
+					tmp =
+					    _create_state_queue(m->scratch,
+								ldfa, bs);
+					if (!h)
+						h = t = tmp;
+					else {
+						t->next = tmp;
+						t = tmp;
+					}
+
+					count++;
+				}
+
+				dfa->lookup[a] = ldfa;
+				set_bits = 0;
+				dm_bit_clear_all(bs);
+			}
+		}
+	}
+
+	log_debug("Matcher built with %d dfa states", count);
+	return 1;
+}
+
+struct dm_regex *dm_regex_create(struct dm_pool *mem, const char **patterns,
+				unsigned num)
+{
+	char *all, *ptr;
+	int i;
+	size_t len = 0;
+	struct rx_node *rx;
+	struct dm_pool *scratch = dm_pool_create("regex matcher", 10 * 1024);
+	struct dm_regex *m;
+
+	if (!scratch) {
+		stack;
+		return NULL;
+	}
+
+	if (!(m = dm_pool_alloc(mem, sizeof(*m)))) {
+		stack;
+		dm_pool_destroy(scratch);
+		return NULL;
+	}
+
+	memset(m, 0, sizeof(*m));
+
+	/* join the regexps together, delimiting with zero */
+	for (i = 0; i < num; i++)
+		len += strlen(patterns[i]) + 8;
+
+	ptr = all = dm_pool_alloc(scratch, len + 1);
+
+	if (!all) {
+		stack;
+		goto bad;
+	}
+
+	for (i = 0; i < num; i++) {
+		ptr += sprintf(ptr, "(.*(%s)%c)", patterns[i], TARGET_TRANS);
+		if (i < (num - 1))
+			*ptr++ = '|';
+	}
+
+	/* parse this expression */
+	if (!(rx = rx_parse_tok(scratch, all, ptr))) {
+		log_error("Couldn't parse regex");
+		goto bad;
+	}
+
+	m->mem = mem;
+	m->scratch = scratch;
+	m->num_nodes = _count_nodes(rx);
+	m->nodes = dm_pool_alloc(scratch, sizeof(*m->nodes) * m->num_nodes);
+
+	if (!m->nodes) {
+		stack;
+		goto bad;
+	}
+
+	_fill_table(m, rx);
+	_create_bitsets(m);
+	_calc_functions(m);
+	_calc_states(m, rx);
+	dm_pool_destroy(scratch);
+	m->scratch = NULL;
+
+	return m;
+
+      bad:
+	dm_pool_destroy(scratch);
+	dm_pool_destroy(mem);
+	return NULL;
+}
+
+static struct dfa_state *_step_matcher(int c, struct dfa_state *cs, int *r)
+{
+	if (!(cs = cs->lookup[(unsigned char) c]))
+		return NULL;
+
+	if (cs->final && (cs->final > *r))
+		*r = cs->final;
+
+	return cs;
+}
+
+int dm_regex_match(struct dm_regex *m, const char *b)
+{
+	struct dfa_state *cs = m->start;
+	int r = 0;
+
+	if (!(cs = _step_matcher(HAT_CHAR, cs, &r)))
+		goto out;
+
+	for (; *b; b++)
+		if (!(cs = _step_matcher(*b, cs, &r)))
+			goto out;
+
+	_step_matcher(DOLLAR_CHAR, cs, &r);
+
+      out:
+	/* subtract 1 to get back to zero index */
+	return r - 1;
+}
Index: device-mapper.work/lib/regex/parse_rx.c
===================================================================
--- /dev/null
+++ device-mapper.work/lib/regex/parse_rx.c
@@ -0,0 +1,360 @@
+/*
+ * Copyright (C) 2001-2004 Sistina Software, Inc. All rights reserved.
+ * Copyright (C) 2004 Red Hat, Inc. All rights reserved.
+ *
+ * This file is part of the device-mapper userspace tools.
+ *
+ * This copyrighted material is made available to anyone wishing to use,
+ * modify, copy, or redistribute it subject to the terms and conditions
+ * of the GNU General Public License v.2.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software Foundation,
+ * Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#include "lib.h"
+#include "parse_rx.h"
+
+struct parse_sp {		/* scratch pad for the parsing process */
+	struct dm_pool *mem;
+	int type;		/* token type, 0 indicates a charset */
+	dm_bitset_t charset;	/* The current charset */
+	const char *cursor;	/* where we are in the regex */
+	const char *rx_end;	/* 1pte for the expression being parsed */
+};
+
+static struct rx_node *_or_term(struct parse_sp *ps);
+
+static void _single_char(struct parse_sp *ps, unsigned int c, const char *ptr)
+{
+	ps->type = 0;
+	ps->cursor = ptr + 1;
+	dm_bit_clear_all(ps->charset);
+	dm_bit_set(ps->charset, c);
+}
+
+/*
+ * Get the next token from the regular expression.
+ * Returns: 1 success, 0 end of input, -1 error.
+ */
+static int _rx_get_token(struct parse_sp *ps)
+{
+	int neg = 0, range = 0;
+	char c, lc = 0;
+	const char *ptr = ps->cursor;
+	if (ptr == ps->rx_end) {	/* end of input ? */
+		ps->type = -1;
+		return 0;
+	}
+
+	switch (*ptr) {
+		/* charsets and ncharsets */
+	case '[':
+		ptr++;
+		if (*ptr == '^') {
+			dm_bit_set_all(ps->charset);
+
+			/* never transition on zero */
+			dm_bit_clear(ps->charset, 0);
+			neg = 1;
+			ptr++;
+
+		} else
+			dm_bit_clear_all(ps->charset);
+
+		while ((ptr < ps->rx_end) && (*ptr != ']')) {
+			if (*ptr == '\\') {
+				/* an escaped character */
+				ptr++;
+				switch (*ptr) {
+				case 'n':
+					c = '\n';
+					break;
+				case 'r':
+					c = '\r';
+					break;
+				case 't':
+					c = '\t';
+					break;
+				default:
+					c = *ptr;
+				}
+			} else if (*ptr == '-' && lc) {
+				/* we've got a range on our hands */
+				range = 1;
+				ptr++;
+				if (ptr == ps->rx_end) {
+					log_error("Incomplete range"
+						  "specification");
+					return -1;
+				}
+				c = *ptr;
+			} else
+				c = *ptr;
+
+			if (range) {
+				/* add lc - c into the bitset */
+				if (lc > c) {
+					char tmp = c;
+					c = lc;
+					lc = tmp;
+				}
+
+				for (; lc <= c; lc++) {
+					if (neg)
+						dm_bit_clear(ps->charset, lc);
+					else
+						dm_bit_set(ps->charset, lc);
+				}
+				range = 0;
+			} else {
+				/* add c into the bitset */
+				if (neg)
+					dm_bit_clear(ps->charset, c);
+				else
+					dm_bit_set(ps->charset, c);
+			}
+			ptr++;
+			lc = c;
+		}
+
+		if (ptr >= ps->rx_end) {
+			ps->type = -1;
+			return -1;
+		}
+
+		ps->type = 0;
+		ps->cursor = ptr + 1;
+		break;
+
+		/* These characters are special, we just return their ASCII
+		   codes as the type.  Sorted into ascending order to help the
+		   compiler */
+	case '(':
+	case ')':
+	case '*':
+	case '+':
+	case '?':
+	case '|':
+		ps->type = (int) *ptr;
+		ps->cursor = ptr + 1;
+		break;
+
+	case '^':
+		_single_char(ps, HAT_CHAR, ptr);
+		break;
+
+	case '$':
+		_single_char(ps, DOLLAR_CHAR, ptr);
+		break;
+
+	case '.':
+		/* The 'all but newline' character set */
+		ps->type = 0;
+		ps->cursor = ptr + 1;
+		dm_bit_set_all(ps->charset);
+		dm_bit_clear(ps->charset, (int) '\n');
+		dm_bit_clear(ps->charset, (int) '\r');
+		dm_bit_clear(ps->charset, 0);
+		break;
+
+	case '\\':
+		/* escaped character */
+		ptr++;
+		if (ptr >= ps->rx_end) {
+			log_error("Badly quoted character at end "
+				  "of expression");
+			ps->type = -1;
+			return -1;
+		}
+
+		ps->type = 0;
+		ps->cursor = ptr + 1;
+		dm_bit_clear_all(ps->charset);
+		switch (*ptr) {
+		case 'n':
+			dm_bit_set(ps->charset, (int) '\n');
+			break;
+		case 'r':
+			dm_bit_set(ps->charset, (int) '\r');
+			break;
+		case 't':
+			dm_bit_set(ps->charset, (int) '\t');
+			break;
+		default:
+			dm_bit_set(ps->charset, (int) *ptr);
+		}
+		break;
+
+	default:
+		/* add a single character to the bitset */
+		ps->type = 0;
+		ps->cursor = ptr + 1;
+		dm_bit_clear_all(ps->charset);
+		dm_bit_set(ps->charset, (int) *ptr);
+		break;
+	}
+
+	return 1;
+}
+
+static struct rx_node *_node(struct dm_pool *mem, int type,
+			     struct rx_node *l, struct rx_node *r)
+{
+	struct rx_node *n = dm_pool_zalloc(mem, sizeof(*n));
+
+	if (n) {
+		if (!(n->charset = dm_bitset_create(mem, 256))) {
+			dm_pool_free(mem, n);
+			return NULL;
+		}
+
+		n->type = type;
+		n->left = l;
+		n->right = r;
+	}
+
+	return n;
+}
+
+static struct rx_node *_term(struct parse_sp *ps)
+{
+	struct rx_node *n;
+
+	switch (ps->type) {
+	case 0:
+		if (!(n = _node(ps->mem, CHARSET, NULL, NULL))) {
+			stack;
+			return NULL;
+		}
+
+		dm_bit_copy(n->charset, ps->charset);
+		_rx_get_token(ps);	/* match charset */
+		break;
+
+	case '(':
+		_rx_get_token(ps);	/* match '(' */
+		n = _or_term(ps);
+		if (ps->type != ')') {
+			log_error("missing ')' in regular expression");
+			return 0;
+		}
+		_rx_get_token(ps);	/* match ')' */
+		break;
+
+	default:
+		n = 0;
+	}
+
+	return n;
+}
+
+static struct rx_node *_closure_term(struct parse_sp *ps)
+{
+	struct rx_node *l, *n;
+
+	if (!(l = _term(ps)))
+		return NULL;
+
+	for (;;) {
+		switch (ps->type) {
+		case '*':
+			n = _node(ps->mem, STAR, l, NULL);
+			break;
+
+		case '+':
+			n = _node(ps->mem, PLUS, l, NULL);
+			break;
+
+		case '?':
+			n = _node(ps->mem, QUEST, l, NULL);
+			break;
+
+		default:
+			return l;
+		}
+
+		if (!n) {
+			stack;
+			return NULL;
+		}
+
+		_rx_get_token(ps);
+		l = n;
+	}
+
+	return n;
+}
+
+static struct rx_node *_cat_term(struct parse_sp *ps)
+{
+	struct rx_node *l, *r, *n;
+
+	if (!(l = _closure_term(ps)))
+		return NULL;
+
+	if (ps->type == '|')
+		return l;
+
+	if (!(r = _cat_term(ps)))
+		return l;
+
+	if (!(n = _node(ps->mem, CAT, l, r)))
+		stack;
+
+	return n;
+}
+
+static struct rx_node *_or_term(struct parse_sp *ps)
+{
+	struct rx_node *l, *r, *n;
+
+	if (!(l = _cat_term(ps)))
+		return NULL;
+
+	if (ps->type != '|')
+		return l;
+
+	_rx_get_token(ps);		/* match '|' */
+
+	if (!(r = _or_term(ps))) {
+		log_error("Badly formed 'or' expression");
+		return NULL;
+	}
+
+	if (!(n = _node(ps->mem, OR, l, r)))
+		stack;
+
+	return n;
+}
+
+struct rx_node *rx_parse_tok(struct dm_pool *mem,
+			     const char *begin, const char *end)
+{
+	struct rx_node *r;
+	struct parse_sp *ps = dm_pool_zalloc(mem, sizeof(*ps));
+
+	if (!ps) {
+		stack;
+		return NULL;
+	}
+
+	ps->mem = mem;
+	ps->charset = dm_bitset_create(mem, 256);
+	ps->cursor = begin;
+	ps->rx_end = end;
+	_rx_get_token(ps);		/* load the first token */
+
+	if (!(r = _or_term(ps))) {
+		log_error("Parse error in regex");
+		dm_pool_free(mem, ps);
+	}
+
+	return r;
+}
+
+struct rx_node *rx_parse_str(struct dm_pool *mem, const char *str)
+{
+	return rx_parse_tok(mem, str, str + strlen(str));
+}
Index: device-mapper.work/lib/regex/parse_rx.h
===================================================================
--- /dev/null
+++ device-mapper.work/lib/regex/parse_rx.h
@@ -0,0 +1,52 @@
+/*
+ * Copyright (C) 2001-2004 Sistina Software, Inc. All rights reserved.
+ * Copyright (C) 2004 Red Hat, Inc. All rights reserved.
+ *
+ * This file is part of the device-mapper userspace tools.
+ *
+ * This copyrighted material is made available to anyone wishing to use,
+ * modify, copy, or redistribute it subject to the terms and conditions
+ * of the GNU General Public License v.2.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software Foundation,
+ * Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#ifndef _LVM_PARSE_REGEX_H
+#define _LVM_PARSE_REGEX_H
+
+enum {
+	CAT,
+	STAR,
+	PLUS,
+	OR,
+	QUEST,
+	CHARSET
+};
+
+/*
+ * We're never going to be running the regex on non-printable
+ * chars, so we can use a couple of these chars to represent the
+ * start and end of a string.
+ */
+#define HAT_CHAR 0x2
+#define DOLLAR_CHAR 0x3
+
+struct rx_node {
+	int type;
+	dm_bitset_t charset;
+	struct rx_node *left, *right;
+
+	/* used to build the dfa for the toker */
+	int nullable, final;
+	dm_bitset_t firstpos;
+	dm_bitset_t lastpos;
+	dm_bitset_t followpos;
+};
+
+struct rx_node *rx_parse_str(struct dm_pool *mem, const char *str);
+struct rx_node *rx_parse_tok(struct dm_pool *mem,
+			     const char *begin, const char *end);
+
+#endif
Index: device-mapper.work/lib/regex/ttree.c
===================================================================
--- /dev/null
+++ device-mapper.work/lib/regex/ttree.c
@@ -0,0 +1,117 @@
+/*
+ * Copyright (C) 2001-2004 Sistina Software, Inc. All rights reserved.
+ * Copyright (C) 2004 Red Hat, Inc. All rights reserved.
+ *
+ * This file is part of the device-mapper userspace tools.
+ *
+ * This copyrighted material is made available to anyone wishing to use,
+ * modify, copy, or redistribute it subject to the terms and conditions
+ * of the GNU General Public License v.2.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software Foundation,
+ * Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#include "lib.h"
+#include "ttree.h"
+
+struct node {
+	unsigned k;
+	struct node *l, *m, *r;
+	void *data;
+};
+
+struct ttree {
+	int klen;
+	struct dm_pool *mem;
+	struct node *root;
+};
+
+static struct node **_lookup_single(struct node **c, unsigned int k)
+{
+	while (*c) {
+		if (k < (*c)->k)
+			c = &((*c)->l);
+
+		else if (k > (*c)->k)
+			c = &((*c)->r);
+
+		else {
+			c = &((*c)->m);
+			break;
+		}
+	}
+
+	return c;
+}
+
+void *ttree_lookup(struct ttree *tt, unsigned *key)
+{
+	struct node **c = &tt->root;
+	int count = tt->klen;
+
+	while (*c && count) {
+		c = _lookup_single(c, *key++);
+		count--;
+	}
+
+	return *c ? (*c)->data : NULL;
+}
+
+static struct node *_tree_node(struct dm_pool *mem, unsigned int k)
+{
+	struct node *n = dm_pool_zalloc(mem, sizeof(*n));
+
+	if (n)
+		n->k = k;
+
+	return n;
+}
+
+int ttree_insert(struct ttree *tt, unsigned int *key, void *data)
+{
+	struct node **c = &tt->root;
+	int count = tt->klen;
+	unsigned int k;
+
+	do {
+		k = *key++;
+		c = _lookup_single(c, k);
+		count--;
+
+	} while (*c && count);
+
+	if (!*c) {
+		count++;
+
+		while (count--) {
+			if (!(*c = _tree_node(tt->mem, k))) {
+				stack;
+				return 0;
+			}
+
+			k = *key++;
+
+			if (count)
+				c = &((*c)->m);
+		}
+	}
+	(*c)->data = data;
+
+	return 1;
+}
+
+struct ttree *ttree_create(struct dm_pool *mem, unsigned int klen)
+{
+	struct ttree *tt;
+
+	if (!(tt = dm_pool_zalloc(mem, sizeof(*tt)))) {
+		stack;
+		return NULL;
+	}
+
+	tt->klen = klen;
+	tt->mem = mem;
+	return tt;
+}
Index: device-mapper.work/lib/regex/ttree.h
===================================================================
--- /dev/null
+++ device-mapper.work/lib/regex/ttree.h
@@ -0,0 +1,26 @@
+/*
+ * Copyright (C) 2001-2004 Sistina Software, Inc. All rights reserved.
+ * Copyright (C) 2004 Red Hat, Inc. All rights reserved.
+ *
+ * This file is part of the device-mapper userspace tools.
+ *
+ * This copyrighted material is made available to anyone wishing to use,
+ * modify, copy, or redistribute it subject to the terms and conditions
+ * of the GNU General Public License v.2.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software Foundation,
+ * Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#ifndef _LVM_TTREE_H
+#define _LVM_TTREE_H
+
+struct ttree;
+
+struct ttree *ttree_create(struct dm_pool *mem, unsigned int klen);
+
+void *ttree_lookup(struct ttree *tt, unsigned *key);
+int ttree_insert(struct ttree *tt, unsigned *key, void *data);
+
+#endif
Index: device-mapper.work/lib/Makefile.in
===================================================================
--- device-mapper.work.orig/lib/Makefile.in
+++ device-mapper.work/lib/Makefile.in
@@ -25,6 +25,9 @@ SOURCES =\
 	libdm-deptree.c \
 	libdm-string.c \
 	libdm-report.c \
+	regex/matcher.c \
+	regex/parse_rx.c \
+	regex/ttree.c \
 	mm/dbg_malloc.c \
 	mm/pool.c \
 	$(interface)/libdm-iface.c

--------------080309060207020107040404
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------080309060207020107040404--
